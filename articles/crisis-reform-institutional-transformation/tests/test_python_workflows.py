from pathlib import Path
import subprocess
import sys


ARTICLE_DIR = Path(__file__).resolve().parents[1]


def run_script(script_name: str):
    script = ARTICLE_DIR / "python" / script_name
    return subprocess.run([sys.executable, str(script)], capture_output=True, text=True)


def test_generate_data_script_runs():
    result = run_script("generate_crisis_reform_data.py")
    assert result.returncode == 0
    assert "Wrote" in result.stdout


def test_simulation_script_runs():
    result = run_script("simulate_crisis_reform_transformation.py")
    assert result.returncode == 0
    assert "Simulation complete" in result.stdout


def test_capture_sensitivity_script_runs():
    result = run_script("capture_risk_sensitivity.py")
    assert result.returncode == 0
    assert "Wrote" in result.stdout


def test_distributional_review_script_runs():
    result = run_script("distributional_reform_review.py")
    assert result.returncode == 0
    assert "Wrote" in result.stdout
