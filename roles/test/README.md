# Test Role for Molecule Testing

This role is dedicated to running molecule tests for other roles in the collection.

## Usage

### Running molecule tests locally

```bash
# Install dependencies
pip install molecule molecule-plugins ansible

# Install role dependencies
ansible-galaxy install -r ../requirements.yaml

# Run molecule tests
molecule test

# Or run specific scenarios
molecule list
molecule converge
molecule verify
molecule destroy
```

### Test Coverage

This role runs molecule tests to verify that other roles in this collection work correctly.

## Test Structure

- `molecule/default/` - Default molecule scenario
  - `molecule.yml` - Molecule configuration
  - `converge.yml` - Convergence playbook (installs the role)
  - `verify.yml` - Verification playbook (asserts role functionality)
