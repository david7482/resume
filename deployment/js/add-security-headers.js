function handler(event) {
    var response = event.response;
    var headers = response.headers;

    /* Add HTTP Strict Transport Security to enforce HTTPS
     * See https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security
     *
     * Strict-Transport-Security: max-age=31536000; includeSubDomains
     */
    headers['strict-transport-security'] = { value: 'max-age=63072000; includeSubdomains; preload'};

    /* Add Content-Security-Policy header to mitigate XSS.
     * See https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP
     *
     * Content-Security-Policy: default-src https: 'self'
     */
    headers['content-security-policy'] = { value: "default-src 'self' 'unsafe-inline' fonts.googleapis.com fonts.gstatic.com use.fontawesome.com www.googletagmanager.com www.google-analytics.com"};

    /* Add MIME-type sniffing protection (also helps with XSS)
     * See https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Content-Type-Options
     *
     * X-Content-Type-Options: nosniff
     */
    headers['x-content-type-options'] = { value: 'nosniff'};

    /* Add X-Frame-Options to disable framing and mitigate clickjacking
     * See https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options
     *
     * X-Frame-Options: DENY
     */
    headers['x-frame-options'] = {value: 'DENY'};

    /* Add browser side XSS protection (for older browsers without CSP)
     * See https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-XSS-Protection
     *
     * X-XSS-Protection: 1; mode=block
     */
    headers['x-xss-protection'] = {value: '1; mode=block'};

    return response;
}