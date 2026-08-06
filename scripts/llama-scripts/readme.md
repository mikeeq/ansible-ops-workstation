# llama.cpp

| | **27B (dense)** | **35B-A3B MoE** |
|---|---|---|
| **Speed** | ~19–20 tok/s | 60–80+ tok/s |
| **Active params/token** | 27B | 3B |
| **Context** | 65K tokens | 256K tokens |
| **RAM usage** | Higher | Lower (MoE) |
| **Coherence/detail** | Better | Good enough |
| **Pi agent suitability** | ⚠️ Hits timeout limits | ✅ Daily driver |
| **Best use** | Planning, brainstorming, chat | Coding agent, long tasks |
| **Quantization (your setup)** | Q4_K_M (via `-hf`) | MXFP4 (local file) |

**Bottom line:** For Pi agent, 35B-A3B wins on every practical metric. 27B is worth keeping for deliberate planning sessions where you want slower, more thorough reasoning.

/login
/model


## KV Cache & Context Window in llama.cpp

### What is the KV cache?

During inference, every token in the context window requires storing **Key** and **Value** tensors for each attention layer. This is the KV cache. Its size is:

$$\text{KV cache} = \text{context\_len} \times \text{layers} \times \text{kv\_heads} \times \text{head\_dim} \times 2 \times \text{dtype\_bytes}$$

For Qwen3-35B-A3B (94 layers, GQA with 8 KV heads, head dim 128, fp16):

| Context | fp16 KV cache |
|---|---|
| 32K | ~3.0 GB |
| 65K | ~6.0 GB |
| 128K | ~12.0 GB |

Your current 65K with q8_0 KV halves that to ~3 GB — leaving you ~0.2 GB headroom out of 24 GB (21.8 GB model + vision encoder + ~3 GB KV = ~22.5 GB, matching your amdgpu_top output).

---

### KV cache quantization (`-ctk` / `-ctv`)

| Flag | Memory | Quality impact |
|---|---|---|
| `f16` (default) | 100% | lossless |
| `q8_0` | ~50% | negligible |
| `q4_0` | ~25% | slight degradation at long context |
| `q4_1` | ~25% | slightly better than q4_0 |

`q8_0` is almost always safe. `q4_0` is fine for most tasks but can degrade coherence on very long documents. **Keys are more sensitive than values** — using `-ctk q8_0 -ctv q4_0` asymmetrically is a common practical choice.

---

### Your hardware budget (24 GB VRAM)

```
~21.8 GB  model weights (Q4_K_M, all layers on GPU)
~0.5 GB   vision encoder (clip)
─────────────────────────────
~1.7 GB   left for KV cache
```

With `-ctk q8_0 -ctv q8_0` that ~1.7 GB supports roughly **~18K context**. You're currently at 65K which exceeds that — llama.cpp likely overflows KV cache to GTT/system RAM (the 2.0 MB GTT shown is low though, possibly because it hasn't been stressed yet).

To reliably use 65K without overflow: switch to q4_0 on values:

```bash
-ctk q8_0 -ctv q4_0
```

Or for 128K, use full q4 on both.

---

### Practical recommendations for your setup

**For coding / long documents (max context):**
```bash
-c 131072 -ctk q4_0 -ctv q4_0 -ngl 92
# free ~2 layers to GPU to make room, put 2 on CPU
```

**Current setup (balanced — good default):**
```bash
-c 65536 -ctk q8_0 -ctv q8_0 -ngl 99
```

**For fast chat (minimal context needed):**
```bash
-c 8192 -ngl 99
# no KV quantization needed, all fits, maximum quality
```

---

### Other relevant parameters

- **`-np` (parallel slots)**: each slot gets its own KV cache. `-np 2` doubles KV memory usage. Keep at 1 unless you need concurrent requests.
- **`--cache-reuse N`**: reuses KV cache across requests when the prompt prefix matches — very useful if you have a large system prompt, saves re-encoding it every turn.
- **`-fa` (flash attention)**: reduces memory bandwidth for KV operations, can slightly increase max usable context. Worth adding.

Add `-fa` to your current script — it's free performance:

Replacing 3 lines with 4 lines in [](file:///home/mikee/git/mikee/ansible-ops-workstation/scripts/llama-scripts/run-35b-amd.sh)


```

```
Flash attention (`-fa`) reduces KV memory bandwidth usage and is compatible with KV quantization — it should give a small speed boost and slightly lower peak VRAM pressure.
