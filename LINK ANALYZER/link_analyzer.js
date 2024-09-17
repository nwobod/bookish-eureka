const linkForm = document.getElementById('link-form');
const resultsDiv = document.getElementById('results');

linkForm.addEventListener('submit', (e) => {
  e.preventDefault();
  const link = document.getElementById('link').value;
  fetch('/analyze', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    body: `link=${link}`
  })
  .then(response => response.json())
  .then(data => {
    resultsDiv.innerHTML = '';
    const networkInfoSection = document.getElementById('network-info');
    networkInfoSection.querySelector('#netrange').textContent = data.netrange;
    networkInfoSection.querySelector('#orgname').textContent = data.orgname;

    const countrySection = document.getElementById('country');
    countrySection.querySelector('#country').textContent = data.country;

    const ipValiditySection = document.getElementById('ip-validity');
    ipValiditySection.querySelector('#ip-validity').textContent = data.ip_validity;

    const malwareDetectionSection = document.getElementById('malware-detection');
    malwareDetectionSection.querySelector('#malware-detection').textContent = data.malware_detection;

    const sqlInjectionDetectionSection = document.getElementById('sql-injection-detection');
    sqlInjectionDetectionSection.querySelector('#sql-injection-detection').textContent = data.sql_injection_detection;
  })
  .catch(error => {
    console.error(error);
    resultsDiv.innerHTML = '<p>Error: ' + error.message + '</p>';
  });
});