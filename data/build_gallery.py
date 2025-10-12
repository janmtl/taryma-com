import pandas as pd
df0 = pd.read_json("gallery.json")
print(df0.head())

artworks_template = """
<div class="gallery-card">
    <a href='https://taryma-com-public.hel1.your-objectstorage.com/artworks/{filename}'>
        <img src='https://taryma-com-public.hel1.your-objectstorage.com/artworks-browse/{filename}' alt='{title}' title='{title}' />
    </a>
    <h4>{title}</h4>
    <p>{technique}, {date_created} ({xcm} x {ycm} cm)</p>
</div>
"""

body_template = """
---
title: "{category}"
---

<div class="gallery-grid">
    {artworks}
</div>
"""

for category, data in df0.groupby("category"):
    category_slug = category.lower().replace(" ", "-")
    artworks = " ".join([
        artworks_template.format(
            title=row['title']  ,
            filename=row['filename'],
            technique=row['technique'],
            date_created=row['date_created'],
            xcm=row['xcm'],
            ycm=row['ycm']
        )
        for _, row in data.iterrows()
    ])
    
    body = body_template.format(
        category=category,
        artworks=artworks
    )
    
    print(f"category_slug: {category_slug}, number of images: {len(data)}")

    with open(f"../content/gallery/{category_slug}.md", "w") as f:
        f.write(body)