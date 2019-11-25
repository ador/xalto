## DB schema

Short docs and the commands to create it.

Schemaname: `xalto`

```
create schema xalto;
```

### Dataset

A collection of pages with handwritten text (eventually: labels as well)

```
CREATE TABLE xalto.dataset (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  created TIMESTAMP DEFAULT NOW()
);
```

### Page

A handwritten page, has an image associated with it somewhere, here we only 
store a url to the image.

```
CREATE TABLE xalto.page (
  id SERIAL PRIMARY KEY,
  url TEXT NOT NULL,
  created TIMESTAMP DEFAULT NOW(),
  dataset_id INTEGER REFERENCES xalto.dataset(id)
);
```

### Line

A hadwritten line of text, has an image associated with it somewhere, here we
only store a url to the image.

`line_no` is a number between 1 and 33, and it's the line number within the
page.

```
CREATE TABLE xalto.line (
  id SERIAL PRIMARY KEY,
  url TEXT NOT NULL,
  page_id INTEGER REFERENCES xalto.page(id),
  line_no INTEGER NOT NULL,
  labeled_as_empty BOOLEAN NOT NULL DEFAULT FALSE,
  labeling_done BOOLEAN NOT NULL DEFAULT FALSE
);
```

### CharLabel

A handwritten character's position within a line and the associated character
label (like `a` or `B` or `-`).

```
CREATE TABLE xalto.charlabel (
  id SERIAL PRIMARY KEY,
  line_id INTEGER REFERENCES xalto.line(id),
  text_label TEXT NOT NULL,
  pos_left_px INTEGER NOT NULL,
  width_px INTEGER NOT NULL DEFAULT 20
);
```


## Create DB roles

### Anonymous user (readonly)

```
create role web_anon nologin;
grant usage on schema xalto to web_anon;
grant select on xalto.dataset to web_anon;
grant select on xalto.page to web_anon;
grant select on xalto.line to web_anon;
grant select on xalto.charlabel to web_anon;
```

### Authenticator

```
create role authenticator2 noinherit login password 'Am8aoNgiEj9iezoo';
grant web_anon to authenticator2;
```

### Xalto user with write access

```
create role xalto_user nologin;
grant xalto_user to authenticator2;

grant usage on schema xalto to xalto_user;
grant all on xalto.dataset to xalto_user;
grant all on xalto.page to xalto_user;
grant all on xalto.line to xalto_user;
grant all on xalto.charlabel to xalto_user;
grant usage, select on sequence xalto.dataset_id_seq to xalto_user;
grant usage, select on sequence xalto.page_id_seq to xalto_user;
grant usage, select on sequence xalto.line_id_seq to xalto_user;
grant usage, select on sequence xalto.charlabel_id_seq to xalto_user;
```
