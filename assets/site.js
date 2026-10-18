(function () {
  // XOR 42. The address is never stored as text, so crawlers that do not run
  // JavaScript cannot harvest it. The PDF still contains it in the clear.
  const email = [78, 88, 67, 92, 79, 88, 4, 79, 78, 88, 69, 106, 77, 71, 75, 67, 70, 4, 73, 69, 71]
    .map(function (n) {
      return String.fromCharCode(n ^ 42);
    })
    .join("");

  const link = document.querySelector(".email");
  if (link) {
    link.href = "mailto:" + email;
    link.textContent = email;
  }

  const copyButton = document.querySelector(".copy");
  const copyStatus = document.querySelector(".copy-status");
  if (!copyButton) return;
  copyButton.hidden = false;

  copyButton.addEventListener("click", async () => {
    let copied = false;
    try {
      await navigator.clipboard.writeText(email);
      copied = true;
    } catch (error) {
      const field = document.createElement("textarea");
      field.value = email;
      field.setAttribute("readonly", "");
      field.style.position = "fixed";
      field.style.left = "-9999px";
      document.body.appendChild(field);
      field.select();
      copied = document.execCommand("copy");
      field.remove();
    }
    if (!copied) return;
    copyButton.dataset.state = "copied";
    copyButton.textContent = "Copied";
    copyStatus.textContent = "Email copied.";
    window.setTimeout(() => {
      copyButton.dataset.state = "";
      copyButton.textContent = "Copy email";
      copyStatus.textContent = "";
    }, 1600);
  });
})();
