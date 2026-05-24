from pathlib import Path
import subprocess
import sys


ARTICLE_DIR = Path(__file__).resolve().parents[1]


def run_script(script_name: str):
    script = ARTICLE_DIR / "python" / script_name
    return subprocess.run([sys.executable, str(script)], capture_output=True, text=True)


def test_generate_data_script_runs():
    result = run_script("generate_compliance_rule_following_data.py")
    assert result.returncode == 0
    assert "Wrote" in result.stdout


def test_simulation_script_runs():
    result = run_script("simulate_rule_following_dynamics.py")
    assert result.returncode == 0
    assert "Simulation complete" in result.stdout


def test_fragile_compliance_review_script_runs():
    result = run_script("fragile_compliance_review.py")
    assert result.returncode == 0
    assert "Wrote" in result.stdout


def test_compliance_burden_review_script_runs():
    result = run_script("compliance_burden_review.py")
    assert result.returncode == 0
    assert "Wrote" in result.stdout


def test_selective_rule_application_sensitivity_script_runs():
    result = run_script("selective_rule_application_sensitivity.py")
    assert result.returncode == 0
    assert "Wrote" in result.stdout
