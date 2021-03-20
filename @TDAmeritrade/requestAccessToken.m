% requestAccessToken.m
% request a new access token using the refresh token
% This may fail if your refresh token is stale
% This method is not meant to be publicly accessible 
%

function response = requestAccessToken(self)


% get a new access token

disp('Requesting access token using OAuth...')
curl_str = 'curl -X POST --header "Content-Type: application/x-www-form-urlencoded" -d "grant_type=refresh_token&refresh_token=$REFRESH_token&access_type=&code=&client_id=$APIKey%40AMER.OAUTHAP" "https://api.tdameritrade.com/v1/oauth2/token"';

curl_str = strrep(curl_str, '$REFRESH_token',urlencode(self.RefreshToken));
curl_str = strrep(curl_str, '$APIKey',self.APIKey);

[e,o] = system(curl_str);

if e ~= 0
	disp('Something went wrong with getting the access token. The error was:')
	disp(o)
	disp('Try getting a new refresh token')
	error('Cannot read access token')
end

response = jsondecode(o);