#!/usr/bin/python3

"""Contains top_ten function"""

import requests

def top_ten(subreddit):

    """Print the titles of the 10 hottest posts on a given subreddit."""

    url = "https://www.reddit.com/r/{}/hot/.json".format(subreddit)
    headers = {"User-Agent": "0x16-api_advanced:project:\v1.0.0 (by /u/firdaus_cartoon_jr)"}
    params = { "limit": 10 }

    response = requests.get(url, headers=headers, params=params, allow_redirects=False)

    if response.status_code == 404:
        print("None")
        return

    try:
        results = response.json().get("data")
        if results is None:
            print("No data found.")
            return

        # Traiter les résultats ici (par exemple, afficher les 10 premiers articles)
        for post in results.get("children", []):
            print(post.get("data").get("title"))

    except ValueError:
        print("Error: Response is not a valid JSON.")
        return