/* 
   --- APP TABLES ---             ||    --- USER TABLES ---
 public | device                  || 
 public | tag                     ||  public | patient_details
 public | organization_details    ||  public | patient_professional
 public | app                     ||  public | professional_organization
 public | app_device              ||  public | organization_admin
 public | app_links               ||  public | session_lookup
 public | app_platform            ||  public | user_details
 public | app_recommendation      ||  public | user_hierarchy
 public | app_review              ||  public | user_role
 public | app_tag
 public | platform

*/

/*====================== USER TABLES ==============================*/
/* -------------------------------- for "organization_details" --- */
INSERT INTO organization_details (organization_name, organization_id)
  VALUES ('USA App Developers',101), ('USA Health Providers',102);


/* ---------------------------------------- for "user_details" --- 
 * ---  And also "user_hierarchy", "user",                     ---
 * ---  "organization_admin", "professional_organization",     ---
 * ---  "patient_professional"                                 ---
 * --------------------------------------------------------------- */

/*INSERT INTO user_details (first_name, last_name, avatar, nickname)
  VALUES ();
*/
\COPY staging.user_details_loader (first_name, last_name, nickname, avatar, roles, organization_name, is_organization_admin, authorized_professionals, authorized_subs) FROM 'minimal_user_details.csv' WITH (FORMAT csv, NULL '', HEADER)
;

/* ------------------------------------- for 'patient_details' --- */
/* Not using patient_details right now but keeping them for later.
     The intent is a table like:
      user_id  facebook_uri    current_feeling
      -------  ------------    ---------------
      <id>     <url>           <'good' 'bad' or 'ok'>
 */


/*======================= APP TABLES ==============================*/
/* ---------------------------------------------- for "device" --- */
INSERT INTO device (device) VALUES ('Fitbit'), ('Nike+FuelBand');

/* -------------------------------------------- for "platform" --- */
INSERT INTO platform (platform) VALUES ('iOS'), ('Android'),('Windows 8.1 OS'),('Blackberry 10 OS');

/* ------------------------------------------------- for "tag" --- */
SELECT insert_tag ('online health communities',NULL);
SELECT insert_tag ('behavioral health wellness',NULL);
SELECT insert_tag ('hospitals',NULL),;
SELECT insert_tag ('government', NULL);

SELECT * FROM tag;

--  Look at the tag hierarchy using category names.
SELECT p.category_name, s.category_name
FROM cat_to_parents AS a
LEFT JOIN tag AS p
  ON a.parent_category_id = p.category_id
JOIN tag as s
  ON a.category_id = s.category_id;

/* ---------------------------------- for "app" via "app_view" --- */
-- OK to INSERT into a view but COPY does not work.
--  For this, a trigger was added to the insert to get the
--  organization_id given the organization_name (because 'app' uses the org ID)
/*INSERT INTO app_view (app_name, organization_name, icon, objective)
  VALUES
('Free Throw Tracker',
  'USA App Developers',
  'BasketTracker.jpg',
    'Keep track of your free throw records, post videos showing your best run, and compete against your friends!'), 
('Kick Perfect','USA App Developers','KickCounter.jpg','Superimpose a master''s kick poses on your own.');
*/
/* --- for "app", "app_platform", "app_device", "app_tag" via "staging.app_view_loader" --- */
-- For bulk loading, use the staging.app_view_loader table: it triggers
-- an INSERT function that matches organization names to org id. 

\COPY staging.app_view_loader (platforms, tags, app_name, app_id, vendor, vendor_id, logo, advertisement_text, description) FROM 'APP.csv' WITH (FORMAT csv, NULL '', HEADER)
;


/* ------------------------------------------- for 'app_links' --- */
/* Not using app_links right now but keeping them for later.
     The intent is a table like:
      app_id  link_coded    link
      ------  ----------    ----
      <id>    <url>         <text for the url>
 */

/* ---------------------------------- for 'app_recommendation' --- */
-- app_id, recipient_id, recommender_id
INSERT INTO staging.app_recommendation_loader (app_name, recommender_nickname, recipient_nickname)
  VALUES
('Helpouts','valentina','tanya'),
('Circleof6','valentina','ivy'),
('Ask Karen','doctor','valentina'),
('MyChart','doctor','ivy');

/* ------------------------------------------ for 'app_review' --- */
-- app_id, user_id, user_role, usability, effectiveness, review, platform_id
INSERT INTO staging.app_review_loader (apP_name, user_nickname, user_role, usability, effectiveness, review, platform)
  VALUES
('HealthVault','valentina','user','good','ok','Reliable and simple app.  It was easy to understand. I was really engaged.','{Windows 8.1 OS}'),
('HealthVault','tanya','user','ok','ok','Discovered how to access my doctor conveniently.  Simmple and user-friendly.','{Windows 8.1 OS}'),
('Just-in-Case','valentina','user','ok','good','Secure and private.  I felt comfortable giving my information.','{iOS}'),
('Just-in-Case','tanya','user','ok','good','Good app but hard to navigate.','{Android}'),
('Keep Spriggy Safe:Game','doctor','health provider','good','good','Super user-friendly app and the process is easy to understand.  I felt comfortable using it.',NULL),
('Keep Spriggy Safe:Game','valentina','user','good','good','My son enjoyed using this app and he learned a lot about his health.','{Android}'),
('Keep Spriggy Safe:Game','appmaker','user','good','good','Free, simple, and improved my knowledge about health for children.','{Blackberry 10 S}'),
('HealthVault','appmaker','user','good','good','Comprehensive, secure, navigable.',NULL),
('Helpouts','doctor','health provider','ok','ok','User-friendly, secure, and great level of engagement for users.',NULL),
('Helpouts','nurse','health provider','good','ok','Because I know I Google, I tried it.  I like the videos.  I think I can talk to my doctor.','{Android}'),
('Helpouts','valentina','user','ok','ok','I like it because my information is secure and private. I understood the intent of the app.','{Android}'),
('PTSD Coach','valentina','user','ok','good','Hard to use but really informative.','{iOS}'),
('MyChart','doctor','health provider','ok','ok','The features of this app make it easy to use and move around. Improved my knowledge significantly.',NULL),
('MyChart','valentina','user','ok','good','I loved competing and collaborating with the information to make decisions but the UI could be easier.','{Android}');


