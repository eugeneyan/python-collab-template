![Tests](https://github.com/eugeneyan/python-collab-template/workflows/Tests/badge.svg) [![codecov](https://codecov.io/gh/eugeneyan/python-collab-template/branch/master/graph/badge.svg)](https://codecov.io/gh/eugeneyan/python-collab-template)

# python-collab-template

Repository for [How to set up a Python Repo for Automation and Collaboration](https://eugeneyan.com/writing/setting-up-python-project-for-automation-and-collaboration/).

## Quickstart
```
# Clone this repo and change directory
git clone git@github.com:eugeneyan/python-collab-template.git
cd python-collab-template

# Create python environment (-B might be needed to execute)
make setup -B

# Run the suite of tests and checks
make check
```

Make a pull request to this repo to see the checks in action 😎

Here's a [sample pull request](https://github.com/eugeneyan/python-collab-template/pull/1) which initially failed ❌ the checks, and then passed ✅.

## Running our checks

In it, we cover the following aspects of setting up a python project, including:

### Unit Tests

```python
@pytest.fixture
def lowercased_df():
    string_col = ['futrelle, mme. jacques heath (lily may peel)',
                  'backstrom, major. karl alfred (maria mathilda gustafsson)']
    df_dict = {'string': string_col}
    df = pd.DataFrame(df_dict)
    return df

def test_extract_title(lowercased_df):
    result = extract_title(lowercased_df, col='string')
    assert result['title'].tolist() == ['mme', 'ms', 'mr', 'lady', 'major']


def test_extract_title_with_replacement(lowercased_df):
    title_replacement = {'mme': 'mrs', 'ms': 'miss', 'lady': 'rare', 'major': 'rare'}
    result = extract_title(lowercased_df, col='string', replace_dict=title_replacement)
    assert result['title'].tolist() == ['mrs', 'miss', 'mr', 'rare', 'rare']
```

```shell
$ pytest
============================= test session starts ==============================
platform darwin -- Python 3.8.2, pytest-5.4.3, py-1.8.2, pluggy-0.13.1
rootdir: /Users/eugene/projects/python-collaboration-template/tests/data_prep
collected 2 items

test_categorical.py::test_extract_title PASSED                           [ 50%]
test_categorical.py::test_extract_title_with_replacement PASSED          [100%]

============================== 2 passed in 0.30s ===============================
```

### Code Coverage
```
$ pytest --cov=src
============================= test session starts ==============================
platform darwin -- Python 3.8.2, pytest-5.4.3, py-1.8.2, pluggy-0.13.1
rootdir: /Users/eugene/projects/python-collaboration-template
plugins: cov-2.10.0
collected 9 items

tests/data_prep/test_categorical.py ....                                 [ 44%]
tests/data_prep/test_continuous.py .....                                 [100%]

---------- coverage: platform darwin, python 3.8.2-final-0 -----------
Name                           Stmts   Miss  Cover
--------------------------------------------------
src/__init__.py                    0      0   100%
src/data_prep/__init__.py          0      0   100%
src/data_prep/categorical.py      12      0   100%
src/data_prep/continuous.py       11      0   100%
--------------------------------------------------
TOTAL                             23      0   100%

============================== 9 passed in 0.49s ===============================
```

### Linting
```
$ pylint src.data_prep.categorical --reports=y
************* Module src.data_prep.categorical
src/data_prep/categorical.py:20:0: C0330: Wrong continued indentation (add 9 spaces).
                        df[title_col].map(replace_dict),
                        ^        | (bad-continuation)
src/data_prep/categorical.py:21:0: C0330: Wrong continued indentation (add 9 spaces).
                        df[title_col])
                        ^        | (bad-continuation)
src/data_prep/categorical.py:16:12: W1401: Anomalous backslash in string: '\.'. String constant might be missing an r prefix. (anomalous-backslash-in-string)
src/data_prep/categorical.py:1:0: C0114: Missing module docstring (missing-module-docstring)
src/data_prep/categorical.py:5:0: C0116: Missing function or method docstring (missing-function-docstring)
src/data_prep/categorical.py:9:0: C0116: Missing function or method docstring (missing-function-docstring)
src/data_prep/categorical.py:14:0: C0116: Missing function or method docstring (missing-function-docstring)

Report
======
12 statements analysed.

...

Messages
--------
+------------------------------+------------+
|message id                    |occurrences |
+==============================+============+
|missing-function-docstring    |3           |
+------------------------------+------------+
|bad-continuation              |2           |
+------------------------------+------------+
|missing-module-docstring      |1           |
+------------------------------+------------+
|anomalous-backslash-in-string |1           |
+------------------------------+------------+

-----------------------------------
Your code has been rated at 4.17/10
```

### Type Checking
```
$ mypy src
src/data_prep/continuous.py:23: error: Incompatible types in assignment (expression has type "str", variable has type "float")
Found 1 error in 1 file (checked 4 source files)
```

```
$ mypy src
Success: no issues found in 4 source files
```

### Wrapping it in a Makefile
```
clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-test:
	rm -f .coverage
	rm -f .coverage.*

clean: clean-pyc clean-test

test: clean
	. .venv/bin/activate && py.test tests --cov=src --cov-report=term-missing --cov-fail-under 95
```

### GitHub Actions with each `git push`
```
# .github/workflows/tests.yml
name: Tests
on: push
jobs:
  tests:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - uses: actions/setup-python@v1
      with:
        python-version: 3.8
        architecture: x64
    - run: make setup
    - run: make check
    - run: bash <(curl -s https://codecov.io/bash)
```

### 👉 View the [article](https://eugeneyan.com/writing/setting-up-python-project-for-automation-and-collaboration/) for the walkthrough.
