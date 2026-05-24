from pathlib import Path
import subprocess
import sys


ARTICLE_DIR = Path(__file__).resolve().parents[1]


def run_script(script_name: str):
    script = ARTICLE_DIR / "python" / script_name
    return subprocess.run([sys.executable, str(script)], capture_output=True, text=True)


def test_generate_data_script_runs():
    result = run_script("generate_authority_legitimacy_data.py")
    assert result.returncode == 0
    assert "Wrote" in result.stdout


def test_simulation_script_runs():
    result = run_script("simulate_legitimacy_dynamics.py")
    assert result.returncode == 0
    assert "Simulation complete" in result.stdout


def test_fragile_legitimacy_review_script_runs():
    result = run_script("fragile_legitimacy_environment_review.py")
    assert result.returncode == 0
    assert "Wrote" in result.stdout


def test_high_arbitrariness_review_script_runs():
    result = run_script("high_arbitrariness_environment_review.py")
    assert result.returncode == 0
    assert "Wrote" in result.stdout


def test_legitimacy_repair_sensitivity_script_runs():
    result = run_script("legitimacy_repair_sensitivity.py")
    assert result.returncode == 0
    assert "Wrote" in result.stdout
