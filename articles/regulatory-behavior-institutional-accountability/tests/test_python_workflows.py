from pathlib import Path
import subprocess
import sys


ARTICLE_DIR = Path(__file__).resolve().parents[1]


def run_script(script_name: str):
    script = ARTICLE_DIR / "python" / script_name
    return subprocess.run([sys.executable, str(script)], capture_output=True, text=True)


def test_generate_data_script_runs():
    result = run_script("generate_regulatory_accountability_data.py")
    assert result.returncode == 0
    assert "Wrote" in result.stdout


def test_simulation_script_runs():
    result = run_script("simulate_regulatory_behavior.py")
    assert result.returncode == 0
    assert "Simulation complete" in result.stdout


def test_fragile_regulation_review_script_runs():
    result = run_script("fragile_regulation_review.py")
    assert result.returncode == 0
    assert "Wrote" in result.stdout


def test_regulatory_burden_review_script_runs():
    result = run_script("regulatory_burden_review.py")
    assert result.returncode == 0
    assert "Wrote" in result.stdout


def test_capture_pressure_sensitivity_script_runs():
    result = run_script("capture_pressure_sensitivity.py")
    assert result.returncode == 0
    assert "Wrote" in result.stdout
