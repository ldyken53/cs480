// Login user
document.getElementById('loginForm').addEventListener('submit', async function(e) {
    e.preventDefault();

    const t_uin = document.getElementById('T_UIN').value;
    const password = document.getElementById('loginPassword').value;
    const data = {
        t_uin: t_uin,
        password: password,
    };

    try {
        const response = await fetch('/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data),
        });

        if (response.ok) {
            const result = await response.json();
            alert(result.message);
            if (result.message == "Login successful!") {
                window.location.href = result.redirect;
            }
        } else {
            const error = await response.text();
            alert(error); // Display error message
        }
    } catch (err) {
        console.error('Error:', err);
        alert('An error occurred. Please try again.');
    }
});
