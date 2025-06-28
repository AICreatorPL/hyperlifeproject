function showTab(tab) {
    document.getElementById('loginTab').classList.toggle('active', tab === 'login');
    document.getElementById('registerTab').classList.toggle('active', tab === 'register');
    document.getElementById('loginForm').style.display = (tab === 'login') ? '' : 'none';
    document.getElementById('registerForm').style.display = (tab === 'register') ? '' : 'none';
    clearMessages();
}

function clearMessages() {
    document.getElementById('loginMsg').textContent = '';
    document.getElementById('registerMsg').textContent = '';
}

// Logowanie
document.getElementById('loginForm').addEventListener('submit', function(e) {
    e.preventDefault();
    clearMessages();
    const username = document.getElementById('loginUsername').value.trim();
    const password = document.getElementById('loginPassword').value;

    if (username.length < 3 || password.length < 3) {
        document.getElementById('loginMsg').textContent = 'Wprowadź poprawne dane.';
        return;
    }

    mta.triggerEvent('hlrpg:login', username, password);
});

// Rejestracja
document.getElementById('registerForm').addEventListener('submit', function(e) {
    e.preventDefault();
    clearMessages();
    const username = document.getElementById('registerUsername').value.trim();
    const password = document.getElementById('registerPassword').value;

    if (username.length < 3 || password.length < 3) {
        document.getElementById('registerMsg').textContent = 'Nazwa i hasło min. 3 znaki!';
        return;
    }

    mta.triggerEvent('hlrpg:register', username, password);
});

// Odbiór wyniku logowania/rejestracji z Lua
mta.addEventListener('hlrpg:loginResult', function(ok, msg) {
    if (ok) {
        document.getElementById('loginMsg').style.color = '#00d08c';
        document.getElementById('loginMsg').textContent = 'Zalogowano! Trwa ładowanie...';
        setTimeout(function() { mta.triggerEvent('hlrpg:closeLoginPanel'); }, 750);
    } else {
        document.getElementById('loginMsg').style.color = '#ff7070';
        document.getElementById('loginMsg').textContent = msg || 'Błąd logowania!';
    }
});

mta.addEventListener('hlrpg:registerResult', function(ok, msg) {
    if (ok) {
        document.getElementById('registerMsg').style.color = '#00d08c';
        document.getElementById('registerMsg').textContent = 'Zarejestrowano! Trwa logowanie...';
        setTimeout(function() { mta.triggerEvent('hlrpg:closeLoginPanel'); }, 750);
    } else {
        document.getElementById('registerMsg').style.color = '#ff7070';
        document.getElementById('registerMsg').textContent = msg || 'Błąd rejestracji!';
    }
});