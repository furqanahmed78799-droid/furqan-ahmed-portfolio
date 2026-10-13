FURQAN AHMED PORTFOLIO — SETUP GUIDE
======================================

WHAT THIS PROJECT DOES
- Public, responsive portfolio site.
- Admin login panel.
- Add / edit / delete projects, videos, photos/designs, and certificates.
- Upload images, MP4/WebM videos, and PDF certificates.
- Published items show automatically on the public site; drafts remain hidden.
- Supabase provides login, database, and file storage.

FILES
- index.html: website and admin interface.
- schema.sql: database table, security policies, and storage bucket setup.
- README_SETUP.txt: this guide.

IMPORTANT
This is a deployable starter project, not a live hosted website yet. You must connect a Supabase project and deploy the site. Never paste a Supabase service_role key into index.html.

STEP 1 — CREATE SUPABASE PROJECT
1. Go to https://supabase.com and create a free project.
2. Open Project Settings > API (or Connect, depending on the dashboard version).
3. Copy the Project URL and the anon/public key.
4. Open Authentication > Users and create your admin user with email and a strong password.
5. Copy the admin user's UUID.

STEP 2 — CREATE DATABASE + STORAGE SECURITY
1. In Supabase, open SQL Editor > New query.
2. Open schema.sql in this project.
3. Replace every occurrence of ADMIN_USER_UUID with your actual admin user's UUID.
4. Run the SQL.
5. The SQL creates the portfolio_items table, public read-only published content, admin-only writes, and the portfolio-files storage bucket.
6. If the admin user changes later, update the policies with the new UUID.

STEP 3 — CONNECT THE WEBSITE
1. Open index.html in a text editor.
2. Find:
   const SUPABASE_URL = "PASTE_SUPABASE_PROJECT_URL_HERE";
   const SUPABASE_ANON_KEY = "PASTE_SUPABASE_ANON_PUBLIC_KEY_HERE";
3. Replace them with your Supabase Project URL and anon/public key.
4. Optional: set LINKEDIN_URL to your real LinkedIn profile URL.
5. Save index.html.
The anon/public key is intended for browser use. Database and storage security must be enforced by the RLS policies in schema.sql. Never use the service_role key in the website.

STEP 4 — DEPLOY THE WEBSITE FREE WITH GITHUB PAGES
1. Create/sign in to GitHub: https://github.com
2. Create a new public repository named furqan-ahmed-portfolio.
3. Upload index.html to the repository root. You may also upload README_SETUP.txt and schema.sql, but do not upload secrets.
4. Open repository Settings > Pages.
5. Under Build and deployment, choose Deploy from a branch, branch main, folder /(root), then Save.
6. Wait for GitHub Pages to publish. Your URL will look like:
   https://YOUR-GITHUB-USERNAME.github.io/furqan-ahmed-portfolio/
7. Open that URL and test the Admin login button.

STEP 5 — HOW TO USE IT
1. Open your published portfolio URL.
2. Select “Admin login”.
3. Sign in with the Supabase admin email and password.
4. Choose Projects, Videos, Photos & Designs, or Certificates.
5. Enter a title, category, and description. Upload a file or paste an external URL.
6. Select Public to show it on your website, or Draft to keep it hidden.
7. Save. The item should appear in the public portfolio automatically.
8. Use Edit/Delete in the admin dashboard to manage existing items.

STORAGE / FILE NOTES
- Images and PDFs are stored in Supabase Storage, not inside the HTML file.
- Uploaded video size is limited to 150 MB in this starter. Large videos are better hosted on YouTube or another video host, then added using the external URL field.
- Supabase free-plan quotas and policies can change; check the current limits on Supabase before relying on it for large video libraries.
- The storage bucket is public so visitors can view portfolio assets. Admin-only upload/delete permissions are enforced by storage policies.
- Avoid uploading private documents, ID proofs, or certificates containing sensitive information you do not want public.

TROUBLESHOOTING
- If gallery is blank: verify the Supabase URL/key, run schema.sql, and check browser console for errors.
- If login fails: confirm the user exists in Supabase Authentication > Users.
- If login works but upload fails: confirm ADMIN_USER_UUID in all SQL policies matches the admin user's UUID.
- If you change the admin account: update the UUID policies.
- If public link is not available yet: check GitHub repository Settings > Pages and wait for the deployment to finish.

FACTUAL PORTFOLIO CONTENT
The initial website text is based on the uploaded resume: BBA Final Year, Mazharul Uloom College, Ambur (Autonomous), Thiruvalluvar University; skills and career interests as listed in the resume; academic project “A Study on Employee Safety Measures” at A. Abdul Hai Tanning Company; Digital Marketing Certificate. No LinkedIn URL was invented.
