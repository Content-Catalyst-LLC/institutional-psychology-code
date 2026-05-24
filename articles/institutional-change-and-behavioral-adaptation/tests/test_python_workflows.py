from pathlib import Path
import subprocess
import sys


ARTICLE_DIR = Path(__file__).resolve().parents[1]


def run_script(script_name: str):
    script = ARTICLE_DIR / "python" / script_name
    return subprocess.run([sys.executable, str(script)], capture_output=True, text=True)


def test_generate_data_script_runs():
    result = run_script("generate_institutional_change_data.py")
    assert result.returncode == 0
    assert "Wrote" in result.stdout


def test_simulation_script_runs():
    result = run_script("simulate_recursive_institutional_change.py")
    assert result.returncode == 0
    assert "Simulation complete" in result.stdout


def test_fragile_adaptation_review_script_runs():
    result = run_script("fragile_adaptation_review.py")
    assert result.returncode == 0
    assert "Wrote" in result.stdout


def test_transition_burden_review_script_runs():
    result = run_script("transition_burden_review.py")
    assert result.returncode == 0
    assert "Wrote" in result.stdout


def test_adaptation_scenario_script_runs():
    result = run_script("adaptation_scenario_analysis.py")
    assert result.returncode == 0
    assert "Wrote" in result.stdout
