const express = require('express');
const path = require('path');
const app = express();
const axios = require('axios');
const { v4: uuidv4 } = require('uuid');
const url = require('url');

// Middleware (optional, depending on needs)
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

charges = {}

// POST route that sends an HTML file
app.post('/charge', async (req, res) => {
    var { token, email, amount, currency, brick_secure_token, brick_charge_id } = req.body;
    var { server_charge_id } = req.query
    try {
        if (server_charge_id) { // 2nd charge
            charge = charges[server_charge_id]
            charge.secure_token = brick_secure_token
            charge.charge_id = brick_charge_id
            delete charges[server_charge_id]
        } else { // 1st charge
            if (!email) {
                email = "test_t3_sdk@gmail.com"
            }
            server_charge_id = uuidv4()
            const pathName = getUrlPathName(req)
            console.log(pathName)
            const redirectUrl = pathName + "?server_charge_id=" + server_charge_id
            charge = {
                token: token,
                email: email,
                amount: amount,
                currency: currency,
                description: "test",
                secure: "1",
                secure_return_method: "url",
                secure_redirect_url: redirectUrl,
            }
            charges[server_charge_id] = charge
        }

        console.log(charge)
        const finalBody = Object.entries(charge)
            .map(([key, value]) => `${key}=${value}`)
            .join('&');
        // Call external API with { name } as body
        const response = await axios.post('https://api.paymentwall.com/api/brick/charge',
            finalBody,
            {
                headers: {
                    'x-apikey': '9d8884beeb76162785fc92639da37a33',
                }
            }
        );

        // Log or handle response from external API if needed
        console.error('External API responded with:', response.data);
        return res.send(response.data)
    } catch (error) {
        console.log(error.response.data)
        res.send(error.response.data);
    }
});

// Start server
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});

const parseCustomQueryItem = (queryString) => {
    // Fix the query string by replacing all '?' with '&', except for the first one
    const fixedQueryString = queryString.replace(/\?/g, '&');

    // Use URLSearchParams to parse the query string
    const params = new URLSearchParams(fixedQueryString);

    // Convert the params to an object
    const queryParams = {};
    params.forEach((value, key) => {
        queryParams[key] = value;
    });
    return queryParams
}

const getUrlPathName = (req) => {
    const fullUrl = req.originalUrl;
    const parsedUrl = url.parse(fullUrl, true); // true means query string is parsed as an object
    const currentUrlWithoutQuery = "http://" + req.headers.host + parsedUrl.pathname;
    return currentUrlWithoutQuery
}