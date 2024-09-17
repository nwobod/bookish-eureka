<?php
// index.php

// Create a form to input the link
echo '<form id="link-form">
  <input type="text" id="link" placeholder="Enter a link">
  <button type="submit">Analyze</button>
  <div id="progress-bar" class="h-4 bg-gray-200 rounded">
    <div id="progress" class="h-4 bg-orange-500 rounded" style="width: 0%"></div>
  </div>
  <div id="results"></div>
</form>';

// Create a JavaScript function to handle the form submission
echo '<script>
  const linkForm = document.getElementById("link-form");
  const progressBar = document.getElementById("progress-bar");
  const progress = document.getElementById("progress");
  const resultsDiv = document.getElementById("results");

  linkForm.addEventListener("submit", (e) => {
    e.preventDefault();
    const link = document.getElementById("link").value;
    const xhr = new XMLHttpRequest();
    xhr.open("POST", "Link_Analyzer_Master1.sh", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.send(`link=${link}`);

    xhr.onreadystatechange = () => {
      if (xhr.readyState === 4 && xhr.status === 200) {
        const response = JSON.parse(xhr.responseText);
        displayResults(response);
      } else {
        updateProgress(xhr.readyState);
      }
    };
  });

  function updateProgress(readyState) {
    let progressWidth = 0;
    switch (readyState) {
      case 1:
        progressWidth = 25;
        progress.style.backgroundColor = "black";
        break;
      case 2:
        progressWidth = 50;
        progress.style.backgroundColor = "red";
        break;
      case 3:
        progressWidth = 75;
        progress.style.backgroundColor = "green";
        break;
      case 4:
        progressWidth = 100;
        progress.style.backgroundColor = "blue";
        break;
    }
    progress.style.width = `${progressWidth}%`;
  }

  function displayResults(response) {
    resultsDiv.innerHTML = "";
    const resultsHTML = `
      <h2>Link Analysis Results</h2>
      <ul>
        <li>Link: ${response.link}</li>
        <li>NetRange: ${response.netrange}</li>
        <li>OrgName: ${response.orgname}</li>
        <li>Country: ${response.country}</li>
        <li>IP Validity: ${response.ip_validity}</li>
        <li>Malware Detection: ${response.malware_detection}</li>
        <li>SQL Injection Detection: ${response.sql_injection_detection}</li>
        <li>Timestamp: ${response.timestamp}</li>
      </ul>
    `;
    resultsDiv.innerHTML = resultsHTML;
  }
</script>';

// Add footer
echo '<footer>
  <h1 style="color: red; font-size:20px;">IVET HUB CYBERSECURITY ALUMINI 2023-2024</h1>
  <strong>NOTE: this software is created for educational purposes & research</strong>
  <h2>DOMINION & PRAISE 2023</h2>
</footer>';