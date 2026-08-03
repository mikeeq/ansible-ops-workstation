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
