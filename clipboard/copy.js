const CopyToClipboard = (value) => {
    const clipboardElement = document.createElement('input');
    clipboardElement.value = value;
    document.body.appendChild(clipboardElement);
    clipboardElement.select();
    document.execCommand('copy');
    document.body.removeChild(clipboardElement);
};

window.addEventListener('message', (event) => {
    if (event.data.type === 'copy') {
        CopyToClipboard(event.data.data);
    }
});
