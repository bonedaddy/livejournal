#
# database schema & data info
#

mark_clustered("useridmap", "userbio", "syncupdates2", "cmdbuffer", "dudata",
               "log2", "logtext2", "logsubject2", "logprop2", "logsec2", 
               "talk2", "talkprop2", "talktext2", "talkleft",
               "userpicblob2", "events"
               );

register_tablecreate("adopt", <<'EOC');
CREATE TABLE adopt (
  adoptid int(10) unsigned NOT NULL auto_increment,
  helperid int(10) unsigned NOT NULL default '0',
  newbieid int(10) unsigned NOT NULL default '0',
  changetime datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (adoptid),
  KEY (helperid),
  KEY (newbieid)
) 
EOC

register_tablecreate("adoptlast", <<'EOC');
CREATE TABLE adoptlast (
  userid int(10) unsigned NOT NULL default '0',
  lastassigned datetime NOT NULL default '0000-00-00 00:00:00',
  lastadopted datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (userid)
) 
EOC

register_tablecreate("authactions", <<'EOC');
CREATE TABLE authactions (
  aaid int(10) unsigned NOT NULL auto_increment,
  userid int(10) unsigned NOT NULL default '0',
  datecreate datetime NOT NULL default '0000-00-00 00:00:00',
  authcode varchar(20) default NULL,
  action varchar(50) default NULL,
  arg1 varchar(255) default NULL,
  PRIMARY KEY  (aaid)
) 
EOC

register_tablecreate("ban", <<'EOC');
CREATE TABLE ban (
  userid int(10) unsigned NOT NULL default '0',
  banneduserid int(10) unsigned NOT NULL default '0',
  KEY (userid),
  PRIMARY KEY  (userid,banneduserid)
) 
EOC

register_tablecreate("clients", <<'EOC');
CREATE TABLE clients (
  clientid smallint(5) unsigned NOT NULL auto_increment,
  client varchar(40) default NULL,
  PRIMARY KEY  (clientid),
  KEY (client)
) 
EOC

post_create("clients", 
            "sqltry" => "INSERT INTO clients (client) SELECT DISTINCT client FROM logins",
            );

register_tablecreate("clientusage", <<'EOC');
CREATE TABLE clientusage (
  userid int(10) unsigned NOT NULL default '0',
  clientid smallint(5) unsigned NOT NULL default '0',
  lastlogin datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (clientid,userid),
  UNIQUE KEY userid (userid,clientid)
) 
EOC
    
post_create("clientusage", 
            "sqltry" => "INSERT INTO clientusage SELECT u.userid, c.clientid, l.lastlogin FROM user u, clients c, logins l WHERE u.user=l.user AND l.client=c.client",
            );

register_tablecreate("codes", <<'EOC');
CREATE TABLE codes (
  type varchar(10) NOT NULL default '',
  code varchar(7) NOT NULL default '',
  item varchar(80) default NULL,
  sortorder smallint(6) NOT NULL default '0',
  PRIMARY KEY  (type,code)
) PACK_KEYS=1
EOC

register_tablecreate("community", <<'EOC');
CREATE TABLE community (
  userid int(10) unsigned NOT NULL default '0',
  ownerid int(10) unsigned NOT NULL default '0',
  membership enum('open','closed') NOT NULL default 'open',
  postlevel enum('members','select','screened') default NULL,
  PRIMARY KEY  (userid)
) 
EOC

register_tablecreate("dirsearchres2", <<'EOC');
CREATE TABLE dirsearchres2 (
  qdigest varchar(32) NOT NULL default '',
  dateins datetime NOT NULL default '0000-00-00 00:00:00',
  userids blob,
  PRIMARY KEY  (qdigest),
  KEY (dateins)
) 
EOC

register_tablecreate("duplock", <<'EOC');
CREATE TABLE duplock (
  realm enum('support','log','comment') NOT NULL default 'support',
  reid int(10) unsigned NOT NULL default '0',
  userid int(10) unsigned NOT NULL default '0',
  digest char(32) NOT NULL default '',
  dupid int(10) unsigned NOT NULL default '0',
  instime datetime NOT NULL default '0000-00-00 00:00:00',
  KEY (realm,reid,userid)
) 
EOC

register_tablecreate("faq", <<'EOC');
CREATE TABLE faq (
  faqid mediumint(8) unsigned NOT NULL auto_increment,
  question text,
  answer text,
  sortorder int(11) default NULL,
  faqcat varchar(20) default NULL,
  lastmodtime datetime default NULL,
  lastmoduserid int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (faqid)
) PACK_KEYS=1
EOC

register_tablecreate("faqcat", <<'EOC');
CREATE TABLE faqcat (
  faqcat varchar(20) NOT NULL default '',
  faqcatname varchar(100) default NULL,
  catorder int(11) default '50',
  PRIMARY KEY  (faqcat)
) PACK_KEYS=1
EOC

register_tablecreate("faquses", <<'EOC');
CREATE TABLE faquses (
  faqid MEDIUMINT UNSIGNED NOT NULL,
  userid INT UNSIGNED NOT NULL,
  dateview DATETIME NOT NULL,
  PRIMARY KEY (userid, faqid),
  KEY (faqid),
  KEY (dateview)
) 
EOC

register_tablecreate("friendgroup", <<'EOC');
CREATE TABLE friendgroup (
  userid int(10) unsigned NOT NULL default '0',
  groupnum tinyint(3) unsigned NOT NULL default '0',
  groupname varchar(30) NOT NULL default '',
  sortorder tinyint(3) unsigned NOT NULL default '50',
  is_public enum('0','1') NOT NULL default '0',
  PRIMARY KEY  (userid,groupnum)
) 
EOC

register_tablecreate("friends", <<'EOC');
CREATE TABLE friends (
  userid int(10) unsigned NOT NULL default '0',
  friendid int(10) unsigned NOT NULL default '0',
  fgcolor char(7) default NULL,
  bgcolor char(7) default NULL,
  groupmask int(10) unsigned NOT NULL default '1',
  showbydefault enum('1','0') NOT NULL default '1',
  PRIMARY KEY  (userid,friendid),
  KEY (friendid)
) 
EOC

register_tablecreate("interests", <<'EOC');
CREATE TABLE interests (
  intid int(10) unsigned NOT NULL auto_increment,
  interest varchar(255) NOT NULL default '',
  intcount mediumint(8) unsigned default NULL,
  PRIMARY KEY  (intid),
  UNIQUE interest (interest)
)
EOC

register_tablecreate("keywords", <<'EOC');
CREATE TABLE keywords (
  kwid int(10) unsigned NOT NULL auto_increment,
  keyword varchar(80) binary NOT NULL default '',
  PRIMARY KEY  (kwid),
  UNIQUE KEY kwidx (keyword)
) 
EOC

register_tablecreate("log", <<'EOC');
CREATE TABLE log (
  ownerid int(10) unsigned NOT NULL default '0',
  posterid int(10) unsigned NOT NULL default '0',
  eventtime datetime default NULL,
  logtime datetime default NULL,
  itemid int(10) unsigned NOT NULL auto_increment,
  compressed char(1) NOT NULL default 'N',
  security enum('public','private','usemask') NOT NULL default 'public',
  allowmask int(10) unsigned NOT NULL default '0',
  replycount smallint(5) unsigned default NULL,
  year smallint(6) NOT NULL default '0',
  month tinyint(4) NOT NULL default '0',
  day tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (itemid),
  KEY (year,month,day),
  KEY (ownerid,year,month,day),
  KEY (eventtime),
  KEY (logtime)
)  
EOC

register_tablecreate("logaccess", <<'EOC');
CREATE TABLE logaccess (
  ownerid int(10) unsigned NOT NULL default '0',
  posterid int(10) unsigned NOT NULL default '0',
  KEY (posterid),
  PRIMARY KEY  (ownerid,posterid)
) 
EOC

register_tablecreate("logprop", <<'EOC');
CREATE TABLE logprop (
  itemid int(10) unsigned NOT NULL default '0',
  propid tinyint(3) unsigned NOT NULL default '0',
  value varchar(255) default NULL,
  PRIMARY KEY  (itemid,propid)
) 
EOC

register_tablecreate("logproplist", <<'EOC');
CREATE TABLE logproplist (
  propid tinyint(3) unsigned NOT NULL auto_increment,
  name varchar(50) default NULL,
  prettyname varchar(60) default NULL,
  sortorder mediumint(8) unsigned default NULL,
  datatype enum('char','num','bool') NOT NULL default 'char',
  des varchar(255) default NULL,
  PRIMARY KEY  (propid),
  UNIQUE KEY name (name)
) 
EOC

register_tablecreate("logsec", <<'EOC');
CREATE TABLE logsec (
  ownerid int(10) unsigned NOT NULL default '0',
  itemid int(10) unsigned NOT NULL default '0',
  allowmask int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (ownerid,itemid)
) 
EOC

register_tablecreate("logsubject", <<'EOC');
CREATE TABLE logsubject (
  itemid int(10) unsigned NOT NULL default '0',
  subject varchar(255) default NULL,
  PRIMARY KEY  (itemid)
) 
EOC

register_tablecreate("logtext", <<'EOC');
CREATE TABLE logtext (
  itemid int(10) unsigned NOT NULL default '0',
  subject varchar(255) default NULL,
  event text,
  PRIMARY KEY  (itemid)
) 
EOC

register_tablecreate("memkeyword", <<'EOC');
CREATE TABLE memkeyword (
  memid int(10) unsigned NOT NULL default '0',
  kwid int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (memid,kwid)
) 
EOC

register_tablecreate("memorable", <<'EOC');
CREATE TABLE memorable (
  memid int(10) unsigned NOT NULL auto_increment,
  userid int(10) unsigned NOT NULL default '0',
  itemid int(10) unsigned NOT NULL default '0',
  des varchar(60) default NULL,
  security enum('public','friends','private') NOT NULL default 'public',
  PRIMARY KEY  (memid),
  UNIQUE KEY userid (userid,itemid),
  KEY (itemid)
) 
EOC

register_tablecreate("moods", <<'EOC');
CREATE TABLE moods (
  moodid int(10) unsigned NOT NULL auto_increment,
  mood varchar(40) default NULL,
  parentmood int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (moodid),
  UNIQUE KEY mood (mood)
) 
EOC

register_tablecreate("moodthemedata", <<'EOC');
CREATE TABLE moodthemedata (
  moodthemeid int(10) unsigned NOT NULL default '0',
  moodid int(10) unsigned NOT NULL default '0',
  picurl varchar(100) default NULL,
  width tinyint(3) unsigned NOT NULL default '0',
  height tinyint(3) unsigned NOT NULL default '0',
  KEY (moodthemeid),
  PRIMARY KEY  (moodthemeid,moodid)
) 
EOC

register_tablecreate("moodthemes", <<'EOC');
CREATE TABLE moodthemes (
  moodthemeid int(10) unsigned NOT NULL auto_increment,
  ownerid int(10) unsigned NOT NULL default '0',
  name varchar(50) default NULL,
  des varchar(100) default NULL,
  is_public enum('Y','N') NOT NULL default 'N',
  PRIMARY KEY  (moodthemeid),
  KEY (is_public),
  KEY (ownerid)
) 
EOC

register_tablecreate("news_sent", <<'EOC');
CREATE TABLE news_sent (
  newsid int(10) unsigned NOT NULL auto_increment,
  newsnum mediumint(8) unsigned NOT NULL default '0',
  user varchar(15) NOT NULL default '',
  datesent datetime default NULL,
  email varchar(100) NOT NULL default '',
  PRIMARY KEY  (newsid),
  KEY (newsnum),
  KEY (user),
  KEY (email)
) PACK_KEYS=1
EOC

register_tablecreate("noderefs", <<'EOC');
CREATE TABLE noderefs (
  nodetype char(1) NOT NULL default '',
  nodeid int(10) unsigned NOT NULL default '0',
  urlmd5 varchar(32) NOT NULL default '',
  url varchar(120) NOT NULL default '',
  PRIMARY KEY  (nodetype,nodeid,urlmd5)
) 
EOC

register_tablecreate("overrides", <<'EOC');
CREATE TABLE overrides (
  user varchar(15) NOT NULL default '',
  override text,
  PRIMARY KEY  (user)
) 
EOC

register_tablecreate("poll", <<'EOC');
CREATE TABLE poll (
  pollid int(10) unsigned NOT NULL auto_increment,
  itemid int(10) unsigned NOT NULL default '0',
  journalid int(10) unsigned NOT NULL default '0',
  posterid int(10) unsigned NOT NULL default '0',
  whovote enum('all','friends') NOT NULL default 'all',
  whoview enum('all','friends','none') NOT NULL default 'all',
  name varchar(255) default NULL,
  PRIMARY KEY  (pollid),
  KEY (itemid),
  KEY (journalid),
  KEY (posterid)
) 
EOC

register_tablecreate("pollitem", <<'EOC');
CREATE TABLE pollitem (
  pollid int(10) unsigned NOT NULL default '0',
  pollqid tinyint(3) unsigned NOT NULL default '0',
  pollitid tinyint(3) unsigned NOT NULL default '0',
  sortorder tinyint(3) unsigned NOT NULL default '0',
  item varchar(255) default NULL,
  PRIMARY KEY  (pollid,pollqid,pollitid)
) 
EOC

register_tablecreate("pollquestion", <<'EOC');
CREATE TABLE pollquestion (
  pollid int(10) unsigned NOT NULL default '0',
  pollqid tinyint(3) unsigned NOT NULL default '0',
  sortorder tinyint(3) unsigned NOT NULL default '0',
  type enum('check','radio','drop','text','scale') default NULL,
  opts varchar(20) default NULL,
  qtext text,
  PRIMARY KEY  (pollid,pollqid)
) 
EOC

register_tablecreate("pollresult", <<'EOC');
CREATE TABLE pollresult (
  pollid int(10) unsigned NOT NULL default '0',
  pollqid tinyint(3) unsigned NOT NULL default '0',
  userid int(10) unsigned NOT NULL default '0',
  value varchar(255) default NULL,
  PRIMARY KEY  (pollid,pollqid,userid),
  KEY (pollid,userid)
) 
EOC

register_tablecreate("pollsubmission", <<'EOC');
CREATE TABLE pollsubmission (
  pollid int(10) unsigned NOT NULL default '0',
  userid int(10) unsigned NOT NULL default '0',
  datesubmit datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (pollid,userid),
  KEY (userid)
) 
EOC

register_tablecreate("priv_list", <<'EOC');
CREATE TABLE priv_list (
  prlid smallint(5) unsigned NOT NULL auto_increment,
  privcode varchar(20) NOT NULL default '',
  privname varchar(40) default NULL,
  des varchar(255) default NULL,
  is_public ENUM('1', '0') DEFAULT '1' NOT NULL,
  PRIMARY KEY  (prlid),
  UNIQUE KEY privcode (privcode)
) 
EOC

register_tablecreate("priv_map", <<'EOC');
CREATE TABLE priv_map (
  prmid mediumint(8) unsigned NOT NULL auto_increment,
  userid int(10) unsigned NOT NULL default '0',
  prlid smallint(5) unsigned NOT NULL default '0',
  arg varchar(40) default NULL,
  PRIMARY KEY  (prmid),
  KEY (userid),
  KEY (prlid)
) 
EOC

register_tablecreate("querybuffer", <<'EOC');
CREATE TABLE querybuffer (
  qbid int(10) unsigned NOT NULL auto_increment,
  tablename varchar(30) NOT NULL default '',
  instime datetime NOT NULL default '0000-00-00 00:00:00',
  query text NOT NULL,
  PRIMARY KEY  (qbid),
  KEY (tablename)
) 
EOC

register_tablecreate("cmdbuffer", <<'EOC');
CREATE TABLE cmdbuffer (
  cbid INT UNSIGNED NOT NULL AUTO_INCREMENT,
  journalid INT UNSIGNED NOT NULL,
  cmd VARCHAR(30) NOT NULL default '',
  instime datetime NOT NULL default '0000-00-00 00:00:00',
  args TEXT NOT NULL,
  PRIMARY KEY  (cbid),
  KEY (cmd),
  KEY (journalid)
) 
EOC

register_tablecreate("randomuserset", <<'EOC');
CREATE TABLE randomuserset (
  rid INT UNSIGNED NOT NULL AUTO_INCREMENT,
  userid INT UNSIGNED NOT NULL,
  PRIMARY KEY  (rid)
) 
EOC

register_tablecreate("schemacols", <<'EOC');
CREATE TABLE schemacols (
  tablename varchar(40) NOT NULL default '',
  colname varchar(40) NOT NULL default '',
  des varchar(255) default NULL,
  PRIMARY KEY  (tablename,colname)
) 
EOC

register_tablecreate("schematables", <<'EOC');
CREATE TABLE schematables (
  tablename varchar(40) NOT NULL default '',
  public_browsable enum('0','1') NOT NULL default '0',
  redist_mode enum('off','insert','replace') NOT NULL default 'off',
  des text,
  PRIMARY KEY  (tablename)
) 
EOC

register_tablecreate("stats", <<'EOC');
CREATE TABLE stats (
  statcat varchar(30) NOT NULL,
  statkey varchar(150) NOT NULL,
  statval int(10) unsigned NOT NULL,
  UNIQUE KEY statcat_2 (statcat,statkey)
) 
EOC

register_tablecreate("style", <<'EOC');
CREATE TABLE style (
  styleid int(11) NOT NULL auto_increment,
  user varchar(15) NOT NULL default '',
  styledes varchar(50) default NULL,
  type varchar(10) NOT NULL default '',
  formatdata text,
  is_public enum('Y','N') NOT NULL default 'N',
  is_embedded enum('Y','N') NOT NULL default 'N',
  is_colorfree enum('Y','N') NOT NULL default 'N',
  opt_cache enum('Y','N') NOT NULL default 'N',
  has_ads enum('Y','N') NOT NULL default 'N',
  lastupdate datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (styleid),
  KEY (user),
  KEY (type)
)  PACK_KEYS=1
EOC

register_tablecreate("support", <<'EOC');
CREATE TABLE support (
  spid int(10) unsigned NOT NULL auto_increment,
  reqtype enum('user','email') default NULL,
  requserid int(10) unsigned NOT NULL default '0',
  reqname varchar(50) default NULL,
  reqemail varchar(70) default NULL,
  state enum('open','closed') default NULL,
  authcode varchar(15) NOT NULL default '',
  spcatid int(10) unsigned NOT NULL default '0',
  subject varchar(80) default NULL,
  timecreate int(10) unsigned default NULL,
  timetouched int(10) unsigned default NULL,
  timeclosed int(10) unsigned default NULL,
  PRIMARY KEY  (spid),
  KEY (state)
) 
EOC

register_tablecreate("supportcat", <<'EOC');
CREATE TABLE supportcat (
  spcatid int(10) unsigned NOT NULL auto_increment,
  catname varchar(80) default NULL,
  sortorder mediumint(8) unsigned NOT NULL default '0',
  basepoints tinyint(3) unsigned NOT NULL default '1',
  PRIMARY KEY  (spcatid)
) 
EOC

register_tablecreate("supportlog", <<'EOC');
CREATE TABLE supportlog (
  splid int(10) unsigned NOT NULL auto_increment,
  spid int(10) unsigned NOT NULL default '0',
  timelogged int(10) unsigned NOT NULL default '0',
  type enum('req','custom','faqref') default NULL,
  faqid mediumint(8) unsigned NOT NULL default '0',
  userid int(10) unsigned NOT NULL default '0',
  message text,
  PRIMARY KEY  (splid),
  KEY (spid)
) 
EOC

register_tablecreate("supportnotify", <<'EOC');
CREATE TABLE supportnotify (
  spcatid int(10) unsigned NOT NULL default '0',
  userid int(10) unsigned NOT NULL default '0',
  level enum('all','new') default NULL,
  KEY (spcatid),
  KEY (userid),
  PRIMARY KEY  (spcatid,userid)
) 
EOC

register_tablecreate("supportpoints", <<'EOC');
CREATE TABLE supportpoints (
  spid int(10) unsigned NOT NULL default '0',
  userid int(10) unsigned NOT NULL default '0',
  points tinyint(3) unsigned default NULL,
  KEY (spid),
  KEY (userid)
) 
EOC

register_tablecreate("syncupdates", <<'EOC');
CREATE TABLE syncupdates (
  userid int(10) unsigned NOT NULL default '0',
  atime datetime NOT NULL default '0000-00-00 00:00:00',
  nodetype char(1) NOT NULL default '',
  nodeid int(10) unsigned NOT NULL default '0',
  atype enum('create','update') NOT NULL default 'create',
  PRIMARY KEY  (userid,nodetype,nodeid),
  KEY (userid,atime)
) 
EOC

register_tablecreate("syncupdates2", <<'EOC');
CREATE TABLE syncupdates2 (
  userid INT UNSIGNED NOT NULL,
  atime DATETIME NOT NULL,
  nodetype CHAR(1) NOT NULL,
  nodeid MEDIUMINT UNSIGNED NOT NULL,
  atype ENUM('create','update','del') NOT NULL DEFAULT 'create',
  PRIMARY KEY  (userid,nodetype,nodeid),
  KEY (userid,atime)
) 
EOC

register_tablecreate("talk", <<'EOC');
CREATE TABLE talk (
  talkid int(10) unsigned NOT NULL auto_increment,
  nodetype char(1) NOT NULL default '',
  nodeid int(10) unsigned NOT NULL default '0',
  parenttalkid int(10) unsigned NOT NULL default '0',
  journalid int(10) unsigned NOT NULL default '0',
  posterid int(10) unsigned NOT NULL default '0',
  datepost datetime NOT NULL default '0000-00-00 00:00:00',
  state char(1) default 'A',
  PRIMARY KEY  (talkid),
  KEY (nodetype,nodeid),
  KEY (journalid,state,nodetype),
  KEY (posterid,nodetype)
) 
EOC

register_tablecreate("talkprop", <<'EOC');
CREATE TABLE talkprop (
  talkid int(10) unsigned NOT NULL default '0',
  tpropid tinyint(3) unsigned NOT NULL default '0',
  value varchar(255) default NULL,
  PRIMARY KEY  (talkid,tpropid)
) 
EOC

register_tablecreate("talkproplist", <<'EOC');
CREATE TABLE talkproplist (
  tpropid smallint(5) unsigned NOT NULL auto_increment,
  name varchar(50) default NULL,
  prettyname varchar(60) default NULL,
  datatype enum('char','num','bool') NOT NULL default 'char',
  des varchar(255) default NULL,
  PRIMARY KEY  (tpropid),
  UNIQUE KEY name (name)
) 
EOC

register_tablecreate("talktext", <<'EOC');
CREATE TABLE talktext (
  talkid int(10) unsigned NOT NULL default '0',
  subject varchar(100) default NULL,
  body text,
  PRIMARY KEY  (talkid)
) 
EOC

register_tablecreate("themecoltypes", <<'EOC');
CREATE TABLE themecoltypes (
  coltype varchar(30) NOT NULL default '',
  des varchar(100) default NULL,
  sortorder smallint(5) unsigned default NULL,
  PRIMARY KEY  (coltype)
) PACK_KEYS=1
EOC

register_tablecreate("themecustom", <<'EOC');
CREATE TABLE themecustom (
  user varchar(15) NOT NULL default '',
  coltype varchar(30) default NULL,
  color varchar(30) default NULL,
  KEY (user)
) PACK_KEYS=1
EOC

register_tablecreate("themedata", <<'EOC');
CREATE TABLE themedata (
  themeid mediumint(8) unsigned NOT NULL default '0',
  coltype varchar(30) default NULL,
  color varchar(30) default NULL,
  KEY (themeid)
) PACK_KEYS=1
EOC

register_tablecreate("themelist", <<'EOC');
CREATE TABLE themelist (
  themeid mediumint(8) unsigned NOT NULL auto_increment,
  name varchar(50) NOT NULL default '',
  PRIMARY KEY  (themeid)
) 
EOC

register_tablecreate("todo", <<'EOC');
CREATE TABLE todo (
  todoid int(10) unsigned NOT NULL auto_increment,
  journalid int(10) unsigned NOT NULL default '0',
  posterid int(10) unsigned NOT NULL default '0',
  ownerid int(10) unsigned NOT NULL default '0',
  statusline varchar(40) default NULL,
  security enum('public','private','friends') NOT NULL default 'public',
  subject varchar(100) default NULL,
  des varchar(255) default NULL,
  priority enum('1','2','3','4','5') NOT NULL default '3',
  datecreate datetime NOT NULL default '0000-00-00 00:00:00',
  dateupdate datetime default NULL,
  datedue datetime default NULL,
  dateclosed datetime default NULL,
  progress tinyint(3) unsigned NOT NULL default '0',
  PRIMARY KEY  (todoid),
  KEY (journalid),
  KEY (posterid),
  KEY (ownerid)
) 
EOC

register_tablecreate("tododep", <<'EOC');
CREATE TABLE tododep (
  todoid int(10) unsigned NOT NULL default '0',
  depid int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (todoid,depid),
  KEY (depid)
) 
EOC

register_tablecreate("todokeyword", <<'EOC');
CREATE TABLE todokeyword (
  todoid int(10) unsigned NOT NULL default '0',
  kwid int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (todoid,kwid)
) 
EOC

register_tablecreate("topic_cats", <<'EOC');
CREATE TABLE topic_cats (
  tpcatid smallint(5) unsigned NOT NULL auto_increment,
  parent smallint(5) unsigned NOT NULL default '0',
  catname varchar(80) default NULL,
  status enum('on','off') NOT NULL default 'off',
  topicsort enum('alpha','date') NOT NULL default 'alpha',
  PRIMARY KEY  (tpcatid),
  KEY (parent)
) 
EOC

register_tablecreate("topic_list", <<'EOC');
CREATE TABLE topic_list (
  tptopid mediumint(8) unsigned NOT NULL auto_increment,
  tpcatid smallint(5) unsigned NOT NULL default '0',
  topname varchar(80) NOT NULL default '',
  des varchar(255) default NULL,
  timeenter int(10) unsigned NOT NULL default '0',
  timeexpire int(10) unsigned default NULL,
  status enum('new','on','off','deny') NOT NULL default 'new',
  PRIMARY KEY  (tptopid),
  KEY (tpcatid),
  KEY (status)
) 
EOC

register_tablecreate("topic_map", <<'EOC');
CREATE TABLE topic_map (
  tpmapid int(10) unsigned NOT NULL auto_increment,
  tptopid mediumint(8) unsigned NOT NULL default '0',
  itemid int(10) unsigned NOT NULL default '0',
  status enum('new','on','off','deny') NOT NULL default 'new',
  screendate datetime NOT NULL default '0000-00-00 00:00:00',
  screenuserid int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (tpmapid),
  KEY (tptopid),
  KEY (status),
  UNIQUE KEY tptopid_2 (tptopid,itemid),
  KEY (screendate),
  KEY (itemid)
) 
EOC

register_tablecreate("tracking", <<'EOC');
CREATE TABLE tracking (
  userid int(10) unsigned NOT NULL default '0',
  acttime datetime default NULL,
  ip char(15) default NULL,
  actdes char(10) default NULL,
  associd int(10) unsigned NOT NULL default '0',
  KEY (userid)
) 
EOC

register_tablecreate("txtmsg", <<'EOC');
CREATE TABLE txtmsg (
  userid int(10) unsigned NOT NULL default '0',
  provider varchar(25) default NULL,
  number varchar(60) default NULL,
  security enum('all','reg','friends') NOT NULL default 'all',
  PRIMARY KEY  (userid)
) 
EOC

register_tablecreate("user", <<'EOC');
CREATE TABLE user (
  userid int(10) unsigned NOT NULL auto_increment,
  user char(15) default NULL,
  caps SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  email char(50) default NULL,
  password char(30) default NULL,
  status char(1) NOT NULL default 'N',
  statusvis char(1) NOT NULL default 'V',
  statusvisdate datetime default NULL,
  name char(50) default NULL,
  bdate date default NULL,
  themeid int(11) NOT NULL default '1',
  moodthemeid int(10) unsigned NOT NULL default '1',
  opt_forcemoodtheme enum('Y','N') NOT NULL default 'N',
  allow_infoshow char(1) NOT NULL default 'Y',
  allow_contactshow char(1) NOT NULL default 'Y',
  allow_getljnews char(1) NOT NULL default 'N',
  opt_showtalklinks char(1) NOT NULL default 'Y',
  opt_whocanreply enum('all','reg','friends') NOT NULL default 'all',
  opt_gettalkemail char(1) NOT NULL default 'Y',
  opt_htmlemail enum('Y','N') NOT NULL default 'Y',
  opt_mangleemail char(1) NOT NULL default 'N',
  useoverrides char(1) NOT NULL default 'N',
  defaultpicid int(10) unsigned default NULL,
  has_bio enum('Y','N') NOT NULL default 'N',
  txtmsg_status enum('none','on','off') NOT NULL default 'none',
  track enum('no','yes') NOT NULL default 'no',
  is_system enum('Y','N') NOT NULL default 'N',
  journaltype enum('P','N','C','S') NOT NULL default 'P',
  lang char(2) NOT NULL default 'EN',
  PRIMARY KEY  (userid),
  UNIQUE KEY user (user),
  KEY (email),
  KEY (status),
  KEY (statusvis)
)  PACK_KEYS=1
EOC

register_tablecreate("userbio", <<'EOC');
CREATE TABLE userbio (
  userid int(10) unsigned NOT NULL default '0',
  bio text,
  PRIMARY KEY  (userid)
) 
EOC

register_tablecreate("userinterests", <<'EOC');
CREATE TABLE userinterests (
  userid int(10) unsigned NOT NULL default '0',
  intid int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (userid,intid),
  KEY (intid)
) 
EOC

register_tablecreate("userpic", <<'EOC');
CREATE TABLE userpic (
  picid int(10) unsigned NOT NULL auto_increment,
  userid int(10) unsigned NOT NULL default '0',
  contenttype char(25) default NULL,
  width smallint(6) NOT NULL default '0',
  height smallint(6) NOT NULL default '0',
  state char(1) NOT NULL default 'N',
  picdate datetime default NULL,
  md5base64 char(22) NOT NULL default '',
  PRIMARY KEY  (picid),
  KEY (userid),
  KEY (state)
) 
EOC

register_tablecreate("userpicblob", <<'EOC');
CREATE TABLE userpicblob (
  picid int(10) unsigned NOT NULL auto_increment,
  imagedata blob,
  PRIMARY KEY  (picid)
) 
EOC

register_tablecreate("userpicblob2", <<'EOC');
CREATE TABLE userpicblob2 (
  userid int unsigned not null,
  picid int unsigned not null,
  imagedata blob,
  PRIMARY KEY (userid, picid)
) 
EOC

register_tablecreate("userpicmap", <<'EOC');
CREATE TABLE userpicmap (
  userid int(10) unsigned NOT NULL default '0',
  kwid int(10) unsigned NOT NULL default '0',
  picid int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (userid,kwid)
) 
EOC

register_tablecreate("userprop", <<'EOC');
CREATE TABLE userprop (
  userid int(10) unsigned NOT NULL default '0',
  upropid smallint(5) unsigned NOT NULL default '0',
  value varchar(60) default NULL,
  PRIMARY KEY  (userid,upropid),
  KEY (upropid,value)
) 
EOC

register_tablecreate("userproplist", <<'EOC');
CREATE TABLE userproplist (
  upropid smallint(5) unsigned NOT NULL auto_increment,
  name varchar(50) default NULL,
  indexed enum('1','0') NOT NULL default '1',
  prettyname varchar(60) default NULL,
  datatype enum('char','num','bool') NOT NULL default 'char',
  des varchar(255) default NULL,
  PRIMARY KEY  (upropid),
  UNIQUE KEY name (name)
) 
EOC

register_tablecreate("userproplite", <<'EOC');
CREATE TABLE userproplite (
  userid int(10) unsigned NOT NULL default '0',
  upropid smallint(5) unsigned NOT NULL default '0',
  value varchar(255) default NULL,
  PRIMARY KEY  (userid,upropid),
  KEY (upropid)
) 
EOC

register_tablecreate("zip", <<'EOC');
CREATE TABLE zip (
  zip varchar(5) NOT NULL default '',
  state char(2) NOT NULL default '',
  city varchar(100) NOT NULL default '',
  PRIMARY KEY  (zip),
  KEY (state)
) PACK_KEYS=1
EOC

register_tablecreate("zips", <<'EOC');
CREATE TABLE zips (
  FIPS char(2) default NULL,
  zip varchar(5) NOT NULL default '',
  State char(2) NOT NULL default '',
  Name varchar(30) NOT NULL default '',
  alloc float(9,7) NOT NULL default '0.0000000',
  pop1990 int(11) NOT NULL default '0',
  lon float(10,7) NOT NULL default '0.0000000',
  lat float(10,7) NOT NULL default '0.0000000',
  PRIMARY KEY  (zip)
) 
EOC

################# above was a snapshot.  now, changes:

register_tablecreate("recent_logtext", <<'EOC');
CREATE TABLE recent_logtext (
  itemid int(10) unsigned NOT NULL default '0',
  subject varchar(255) default NULL,
  event text,
  PRIMARY KEY  (itemid)
)  
EOC

register_tablecreate("recent_talktext", <<'EOC');
CREATE TABLE recent_talktext (
  talkid int(10) unsigned NOT NULL default '0',
  subject varchar(100) default NULL,
  body text,
  PRIMARY KEY  (talkid)
)  
EOC

register_tablecreate("log2", <<'EOC');
CREATE TABLE log2 (
  journalid INT UNSIGNED NOT NULL default '0',
  jitemid MEDIUMINT UNSIGNED NOT NULL auto_increment,
  PRIMARY KEY  (journalid, jitemid),
  posterid int(10) unsigned NOT NULL default '0',
  eventtime datetime default NULL,
  logtime datetime default NULL,
  compressed char(1) NOT NULL default 'N',
  anum TINYINT UNSIGNED NOT NULL,
  security enum('public','private','usemask') NOT NULL default 'public',
  allowmask int(10) unsigned NOT NULL default '0',
  replycount smallint(5) unsigned default NULL,
  year smallint(6) NOT NULL default '0',
  month tinyint(4) NOT NULL default '0',
  day tinyint(4) NOT NULL default '0',
  rlogtime int(10) unsigned NOT NULL default '0',
  revttime int(10) unsigned NOT NULL default '0',
  KEY (year,month,day),
  KEY (journalid,year,month,day),
  KEY (logtime),
  KEY `rlogtime` (`journalid`,`rlogtime`),
  KEY `revttime` (`journalid`,`revttime`),
  KEY `posterid` (`posterid`,`journalid`)
) 
EOC

register_tablecreate("logtext2", <<'EOC');
CREATE TABLE logtext2 (
  journalid INT UNSIGNED NOT NULL,
  jitemid MEDIUMINT UNSIGNED NOT NULL,
  subject VARCHAR(255) DEFAULT NULL,
  event TEXT,
  PRIMARY KEY (journalid, jitemid)
) max_rows=100000000
EOC

register_tablecreate("logsubject2", <<'EOC');
CREATE TABLE logsubject2 (
  journalid INT UNSIGNED NOT NULL,
  jitemid MEDIUMINT UNSIGNED NOT NULL,
  subject VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (journalid, jitemid)
) max_rows=100000000
EOC

register_tablecreate("logprop2", <<'EOC');
CREATE TABLE logprop2 (
  journalid  INT UNSIGNED NOT NULL,
  jitemid MEDIUMINT UNSIGNED NOT NULL,
  propid TINYINT unsigned NOT NULL,
  value VARCHAR(255) default NULL,
  PRIMARY KEY (journalid,jitemid,propid)
)
EOC

register_tablecreate("logsec2", <<'EOC');
CREATE TABLE logsec2 (
  journalid INT UNSIGNED NOT NULL,
  jitemid MEDIUMINT UNSIGNED NOT NULL,
  allowmask INT UNSIGNED NOT NULL,
  PRIMARY KEY (journalid,jitemid)
)
EOC

register_tablecreate("talk2", <<'EOC');
CREATE TABLE talk2 (
  journalid INT UNSIGNED NOT NULL,  
  jtalkid MEDIUMINT UNSIGNED NOT NULL auto_increment,
  nodetype CHAR(1) NOT NULL DEFAULT '',
  nodeid INT UNSIGNED NOT NULL default '0',
  parenttalkid MEDIUMINT UNSIGNED NOT NULL,
  posterid INT UNSIGNED NOT NULL default '0',
  datepost DATETIME NOT NULL default '0000-00-00 00:00:00',
  state CHAR(1) default 'A',
  PRIMARY KEY  (journalid,jtalkid),
  KEY (nodetype,journalid,nodeid),
  KEY (journalid,state,nodetype),
  KEY (posterid)
) 
EOC

register_tablecreate("talkprop2", <<'EOC');
CREATE TABLE talkprop2 (
  journalid INT UNSIGNED NOT NULL,
  jtalkid MEDIUMINT UNSIGNED NOT NULL,
  tpropid TINYINT UNSIGNED NOT NULL,
  value VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY  (journalid,jtalkid,tpropid)
)
EOC

register_tablecreate("talktext2", <<'EOC');
CREATE TABLE talktext2 (
  journalid INT UNSIGNED NOT NULL,
  jtalkid MEDIUMINT UNSIGNED NOT NULL,
  subject VARCHAR(100) DEFAULT NULL,
  body TEXT,
  PRIMARY KEY (journalid, jtalkid)
) max_rows=100000000
EOC

register_tablecreate("talkleft", <<'EOC');
CREATE TABLE talkleft (
  userid    INT UNSIGNED NOT NULL,
  posttime  INT UNSIGNED NOT NULL,
  INDEX (userid, posttime),
  journalid  INT UNSIGNED NOT NULL,
  nodetype   CHAR(1) NOT NULL,
  nodeid     INT UNSIGNED NOT NULL,
  INDEX (journalid, nodetype, nodeid),
  jtalkid    MEDIUMINT UNSIGNED NOT NULL,
  publicitem   ENUM('1','0') NOT NULL DEFAULT '1'
)
EOC

register_tablecreate("talkleft_xfp", <<'EOC');
CREATE TABLE talkleft_xfp (
  userid    INT UNSIGNED NOT NULL,
  posttime  INT UNSIGNED NOT NULL,
  INDEX (userid, posttime),
  journalid  INT UNSIGNED NOT NULL,
  nodetype   CHAR(1) NOT NULL,
  nodeid     INT UNSIGNED NOT NULL,
  INDEX (journalid, nodetype, nodeid),
  jtalkid    MEDIUMINT UNSIGNED NOT NULL,
  publicitem   ENUM('1','0') NOT NULL DEFAULT '1'
)
EOC

register_tabledrop("ibill_codes");
register_tabledrop("paycredit");
register_tabledrop("payments");
register_tabledrop("tmp_contributed");
register_tabledrop("transferinfo");
register_tabledrop("contest1");
register_tabledrop("contest1data");
register_tabledrop("logins");
register_tabledrop("hintfriendsview");
register_tabledrop("hintlastnview");
register_tabledrop("batchdelete");
register_tabledrop("ftpusers");

register_tablecreate("portal", <<'EOC');
CREATE TABLE portal (
  userid int(10) unsigned NOT NULL default '0',
  loc enum('left','main','right','moz') NOT NULL default 'left',
  pos tinyint(3) unsigned NOT NULL default '0',
  boxname varchar(30) default NULL,
  boxargs varchar(255) default NULL,
  PRIMARY KEY  (userid,loc,pos),
  KEY boxname (boxname)
) 
EOC

register_tablecreate("infohistory", <<'EOC');
CREATE TABLE infohistory (
  userid int(10) unsigned NOT NULL default '0',
  what varchar(15) NOT NULL default '',
  timechange datetime NOT NULL default '0000-00-00 00:00:00',
  oldvalue varchar(255) default NULL,
  other varchar(30) default NULL,
  KEY userid (userid)
) 
EOC

register_tablecreate("useridmap", <<'EOC');
CREATE TABLE useridmap (
  userid int(10) unsigned NOT NULL,
  user char(15) NOT NULL,
  PRIMARY KEY  (userid),
  UNIQUE KEY user (user)
) PACK_KEYS=1
EOC

post_create("useridmap",
            "sql" => "REPLACE INTO useridmap (userid, user) SELECT userid, user FROM user",
            );

register_tablecreate("userusage", <<'EOC');
CREATE TABLE userusage
(
   userid INT UNSIGNED NOT NULL,
   PRIMARY KEY (userid),
   timecreate DATETIME NOT NULL,
   timeupdate DATETIME,
   timecheck DATETIME,
   lastitemid INT UNSIGNED NOT NULL DEFAULT '0',
   INDEX (timeupdate)
)
EOC

register_tablecreate("userupdate", <<'EOC');
CREATE TABLE userupdate
(
   userid   INT UNSIGNED NOT NULL,
   groupbit TINYINT UNSIGNED NOT NULL,
   PRIMARY KEY (userid, groupbit),
   timeupdate DATETIME NOT NULL
)
EOC


post_create("userusage",
            "sqltry" => "INSERT IGNORE INTO userusage (userid, timecreate, timeupdate, timecheck, lastitemid) SELECT userid, timecreate, timeupdate, timecheck, lastitemid FROM user",
            "sqltry" => "ALTER TABLE user DROP timecreate, DROP timeupdate, DROP timecheck, DROP lastitemid",
            );

register_tablecreate("acctcode", <<'EOC');
CREATE TABLE acctcode
(
  acid    INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  userid  INT UNSIGNED NOT NULL,
  rcptid  INT UNSIGNED NOT NULL DEFAULT 0,
  auth    CHAR(5) NOT NULL,
  INDEX (userid),
  INDEX (rcptid)
)
EOC

register_tablecreate("meme", <<'EOC');
CREATE TABLE meme (
  url       VARCHAR(150) NOT NULL,
  posterid  INT UNSIGNED NOT NULL,
  UNIQUE (url, posterid),
  ts        TIMESTAMP,
  itemid    INT UNSIGNED NOT NULL,
  INDEX (ts)
)
EOC

register_tablecreate("statushistory", <<'EOC');
CREATE TABLE statushistory (
  userid    INT UNSIGNED NOT NULL,
  adminid   INT UNSIGNED NOT NULL,
  shtype    VARCHAR(20) NOT NULL,
  shdate    TIMESTAMP NOT NULL,
  notes     TEXT,
  INDEX (userid, shdate),
  INDEX (adminid, shdate),
  INDEX (adminid, shtype, shdate),
  INDEX (shtype, shdate)
)
EOC

register_tablecreate("includetext", <<'EOC');
CREATE TABLE includetext (
  incname  VARCHAR(80) NOT NULL PRIMARY KEY,
  inctext  TEXT,
  updatetime   INT UNSIGNED NOT NULL,
  INDEX (updatetime)
)
EOC

register_tablecreate("oldids", <<'EOC');
CREATE TABLE oldids (
  area     CHAR(1) NOT NULL,
  oldid    INT UNSIGNED NOT NULL,
  UNIQUE (area, oldid),
  userid   INT UNSIGNED NOT NULL,
  newid    INT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (area,userid, newid),
  INDEX (userid)
)
EOC

register_tablecreate("dudata", <<'EOC');
CREATE TABLE dudata (
  userid   INT UNSIGNED NOT NULL,
  area     CHAR(1) NOT NULL,
  areaid   INT UNSIGNED NOT NULL,
  bytes    MEDIUMINT UNSIGNED NOT NULL,
  PRIMARY KEY (userid, area, areaid)
)
EOC

register_tablecreate("dbinfo", <<'EOC');
CREATE TABLE dbinfo (
  dbid    TINYINT UNSIGNED NOT NULL,
  name    VARCHAR(25),
  fdsn      VARCHAR(255),
  rootfdsn  VARCHAR(255),
  masterid  TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (dbid),
  UNIQUE (name)
)
EOC

register_tablecreate("dbweights", <<'EOC');
CREATE TABLE dbweights (
  dbid    TINYINT UNSIGNED NOT NULL,
  role    VARCHAR(25) NOT NULL,
  PRIMARY KEY (dbid, role),
  norm    TINYINT UNSIGNED NOT NULL,
  curr    TINYINT UNSIGNED NOT NULL
)
EOC

# notification/subscription stuff:

register_tablecreate("subs", <<'EOC');  # global
CREATE TABLE subs (
  userid INT UNSIGNED NOT NULL,
  etype       CHAR(1) NOT NULL,
  ejournalid  INT UNSIGNED NOT NULL,
  eiarg       INT UNSIGNED NOT NULL,
  UNIQUE (userid, etype, ejournalid, eiarg),
  INDEX (etype, ejournalid, eiarg),
  subtime     DATETIME NOT NULL,
  exptime     DATETIME NOT NULL,
  INDEX (exptime),
  ntype      CHAR(1) NOT NULL
)
EOC

register_tablecreate("events", <<'EOC');  # clustered
CREATE TABLE events (
  evtime  DATETIME NOT NULL,
  INDEX (evtime),
  etype  CHAR(1) NOT NULL,
  ejournalid  INT UNSIGNED NOT NULL,
  eiarg       INT UNSIGNED NOT NULL,
  duserid   INT UNSIGNED NOT NULL,
  diarg     INT UNSIGNED NOT NULL
)
EOC

### changes

register_alter(sub {

    my $dbh = shift;
    my $runsql = shift;

    if (column_type("supportcat", "is_selectable") eq "")
    {
        do_alter("supportcat",
                 "ALTER TABLE supportcat ADD is_selectable ENUM('1','0') ".
                 "NOT NULL DEFAULT '1', ADD public_read  ENUM('1','0') NOT ".
                 "NULL DEFAULT '1', ADD public_help ENUM('1','0') NOT NULL ".
                 "DEFAULT '1', ADD allow_screened ENUM('1','0') NOT NULL ".
                 "DEFAULT '0', ADD replyaddress VARCHAR(50), ADD hide_helpers ".
                 "ENUM('1','0') NOT NULL DEFAULT '0' AFTER allow_screened");
        
    }
    if (column_type("supportlog", "type") =~ /faqref/)
    {
        do_alter("supportlog",
                 "ALTER TABLE supportlog MODIFY type ENUM('req', 'answer', ".
                 "'custom', 'faqref', 'comment', 'internal', 'screened') ".
                 "NOT NULL");
        do_sql("UPDATE supportlog SET type='answer' WHERE type='custom'");
        do_sql("UPDATE supportlog SET type='answer' WHERE type='faqref'");
        do_alter("supportlog",
                 "ALTER TABLE supportlog MODIFY type ENUM('req', 'answer', ".
                 "'comment', 'internal', 'screened') NOT NULL");
        
    }
    if (table_relevant("supportcat") && column_type("supportcat", "catkey") eq "") 
    {
        do_alter("supportcat",
                 "ALTER TABLE supportcat ADD catkey VARCHAR(25) AFTER spcatid");
        do_sql("UPDATE supportcat SET catkey=spcatid WHERE catkey IS NULL");
        do_alter("supportcat",
                 "ALTER TABLE supportcat MODIFY catkey VARCHAR(25) NOT NULL");
    }
    if (column_type("supportcat", "no_autoreply") eq "") 
    {
        do_alter("supportcat",
                 "ALTER TABLE supportcat ADD no_autoreply ENUM('1', '0') ".
                 "NOT NULL DEFAULT '0'");
    }
    
    if (column_type("support", "timelasthelp") eq "")
    {
        do_alter("supportlog",
                 "ALTER TABLE supportlog ADD INDEX (userid)");
        do_alter("support",
                 "ALTER TABLE support ADD timelasthelp INT UNSIGNED");
    }
    
    if (column_type("user", "track") !~ /temp/)
    {
        do_alter("tracking",
                 "ALTER TABLE tracking ADD INDEX(ip)");
        do_alter("user",
                 "ALTER TABLE user MODIFY track ENUM('no','yes','temp'), ADD INDEX(track)");
    }

    if (column_type("duplock", "realm") !~ /payments/)
    {
        do_alter("duplock",
                 "ALTER TABLE duplock MODIFY realm ENUM('support','log',".
                 "'comment','payments') NOT NULL default 'support'");
    }

    if (column_type("schematables", "redist_where") eq "")
    {
        do_alter("schematables",
                 "ALTER TABLE schematables ADD ".
                 "redist_where varchar(255) AFTER redist_mode");
    }
    
    # upgrade people to the new capabilities system.  if they're
    # using the the paidfeatures column already, we'll assign them
    # the same capability bits that ljcom will be using.
    if (table_relevant("user") && column_type("user", "caps") eq "")
    {
        do_alter("user",
                 "ALTER TABLE user ADD ".
                 "caps SMALLINT UNSIGNED NOT NULL DEFAULT 0 AFTER user");
        try_sql("UPDATE user SET caps=16|8|2 WHERE paidfeatures='on'");
        try_sql("UPDATE user SET caps=8|2    WHERE paidfeatures='paid'");
        try_sql("UPDATE user SET caps=4|2    WHERE paidfeatures='early'");
        try_sql("UPDATE user SET caps=2      WHERE paidfeatures='off'");
    }

    # axe this column (and its two related ones) if it exists.
    if (column_type("user", "paidfeatures"))
    {
        try_sql("REPLACE INTO paiduser (userid, paiduntil, paidreminder) ".
                "SELECT userid, paiduntil, paidreminder FROM user WHERE paidfeatures='paid'");
        try_sql("REPLACE INTO paiduser (userid, paiduntil, paidreminder) ".
                "SELECT userid, COALESCE(paiduntil,'0000-00-00'), NULL FROM user WHERE paidfeatures='on'");
        do_alter("user",
                 "ALTER TABLE user DROP paidfeatures, DROP paiduntil, DROP paidreminder");
    }

    if (table_relevant("log") && column_type("log", "revttime") eq "")
    {
        do_alter("log",
                 "ALTER TABLE log DROP INDEX eventtime, ADD COLUMN rlogtime INT UNSIGNED NOT NULL DEFAULT 0, ADD COLUMN revttime INT UNSIGNED NOT NULL DEFAULT 0, ADD INDEX rlogtime (ownerid, rlogtime), ADD INDEX revttime (ownerid, revttime), ADD INDEX posterid (posterid, ownerid)");
        do_sql("UPDATE log SET revttime=POW(2,31)-1-UNIX_TIMESTAMP(eventtime), rlogtime=POW(2,31)-1-UNIX_TIMESTAMP(logtime) WHERE revttime=0 OR rlogtime=0");
        
        # related, done at same time:
        do_alter("talk",
                 "ALTER TABLE talk ADD INDEX datepost (datepost), DROP INDEX posterid, ADD INDEX posterid (posterid, nodetype, datepost)");
    }

    # move S1 _style ids to userprop table!
    if (column_type("user", "lastn_style")) {

        # be paranoid and insert these in case they don't exist:
        try_sql("INSERT INTO userproplist VALUES (null, 's1_lastn_style', 0, 'Recent View StyleID', 'num', 'The style ID# of the S1 style for the recent entries view.')");
        try_sql("INSERT INTO userproplist VALUES (null, 's1_calendar_style', 0, 'Calendar View StyleID', 'num', 'The style ID# of the S1 style for the calendar view.')");
        try_sql("INSERT INTO userproplist VALUES (null, 's1_day_style', 0, 'Day View StyleID', 'num', 'The style ID# of the S1 style for the day view.')");
        try_sql("INSERT INTO userproplist VALUES (null, 's1_friends_style', 0, 'Friends View StyleID', 'num', 'The style ID# of the S1 style for the friends view.')");
        
        foreach my $v (qw(lastn day calendar friends)) {
            do_sql("INSERT INTO userproplite SELECT u.userid, upl.upropid, u.${v}_style FROM user u, userproplist upl WHERE upl.name='s1_${v}_style'");
        }
        
        do_alter("user",
                 "ALTER TABLE user DROP lastn_style, DROP calendar_style, DROP search_style, DROP searchres_style, DROP day_style, DROP friends_style");
    }

    # add scope columns to proplist tables
    if (column_type("userproplist", "scope") eq "") {
        do_alter("userproplist",
                 "ALTER TABLE userproplist ADD scope ENUM('general', 'local') ".
                 "DEFAULT 'general' NOT NULL");
    }

    if (column_type("logproplist", "scope") eq "") {
        do_alter("logproplist",
                 "ALTER TABLE logproplist ADD scope ENUM('general', 'local') ".
                 "DEFAULT 'general' NOT NULL");
    }

    if (column_type("talkproplist", "scope") eq "") {
        do_alter("talkproplist",
                 "ALTER TABLE talkproplist ADD scope ENUM('general', 'local') ".
                 "DEFAULT 'general' NOT NULL");
    }

    if (column_type("priv_list", "scope") eq "") {
        do_alter("priv_list",
                 "ALTER TABLE priv_list ADD scope ENUM('general', 'local') ".
                 "DEFAULT 'general' NOT NULL");
    }

    # change size of stats table to accomodate meme data, and shrink statcat,
    # since it's way too big
    if (column_type("stats", "statcat") eq "varchar(100)") {
        do_alter("stats",
                 "ALTER TABLE stats ".
                 "MODIFY statcat VARCHAR(30) NOT NULL, ".
                 "MODIFY statkey VARCHAR(150) NOT NULL, ".
                 "MODIFY statval INT UNSIGNED NOT NULL, ". 
                 "DROP INDEX statcat");
    } 

    if (column_type("priv_list", "is_public") eq "") {
        do_alter("priv_list",
                 "ALTER TABLE priv_list ".
                 "ADD is_public ENUM('1', '0') DEFAULT '1' NOT NULL");
    }

    if (column_type("randomuserset", "rid") eq "") {
        do_alter("randomuserset",
                 "ALTER TABLE randomuserset DROP PRIMARY KEY, DROP timeupdate, ".
                 "ADD rid INT UNSIGNED NOT NULL AUTO_INCREMENT FIRST, ADD PRIMARY KEY (rid)");
    }

    # cluster stuff!
    if (column_type("meme", "journalid") eq "") {
        do_alter("meme",
                 "ALTER TABLE meme ADD journalid INT UNSIGNED NOT NULL AFTER ts");
    }

    if (column_type("topic_map", "jitemid") eq "") {
        do_alter("topic_map",
                 "ALTER TABLE topic_map DROP INDEX tptopid_2, DROP INDEX itemid, ".
                 "ADD journalid INT UNSIGNED NOT NULL AFTER tptopid, ".
                 "CHANGE itemid jitemid INT UNSIGNED NOT NULL, ".
                 "ADD UNIQUE tptopid_2 (tptopid, journalid, jitemid), ".
                 "ADD KEY jitem (journalid, jitemid)");
    }

    if (column_type("memorable", "jitemid") eq "") {
        do_alter("memorable", "ALTER TABLE memorable ".
                 "DROP INDEX userid, DROP INDEX itemid, ".
                 "CHANGE itemid jitemid INT UNSIGNED NOT NULL, ".
                 "ADD journalid INT UNSIGNED NOT NULL AFTER userid, ".
                 "ADD UNIQUE uniq (userid, journalid, jitemid), ".
                 "ADD KEY item (journalid, jitemid)");
    }

    if (column_type("user", "clusterid") eq "") {
        do_alter("user", "ALTER TABLE user ".
                 "ADD clusterid TINYINT UNSIGNED NOT NULL AFTER caps, ".
                 "ADD dversion TINYINT UNSIGNED NOT NULL AFTER clusterid, ".
                 "ADD INDEX idxcluster (clusterid), ".
                 "ADD INDEX idxversion (dversion)");
    }

    if (column_type("friends", "bgcolor") eq "char(7)") {
        do_alter("friends", "ALTER TABLE friends ".
                 "MODIFY bgcolor CHAR(8) NOT NULL DEFAULT '16777215', ".
                 "MODIFY fgcolor CHAR(8) NOT NULL DEFAULT '0'");
        do_sql("UPDATE friends SET ".
               "bgcolor=CONV(RIGHT(bgcolor,6),16,10), ".
               "fgcolor=CONV(RIGHT(fgcolor,6),16,10)")
            unless skip_opt() eq "colorconv";
    }

    return if skip_opt() eq "colorconv";

    if (column_type("friends", "bgcolor") eq "char(8)") {
        do_alter("friends", "ALTER TABLE friends ".
                 "MODIFY bgcolor MEDIUMINT UNSIGNED NOT NULL DEFAULT 16777215, ".
                 "MODIFY fgcolor MEDIUMINT UNSIGNED NOT NULL DEFAULT 0");
    }

    # add the default encoding field, for recoding older pre-Unicode stuff

    if (column_type("user", "oldenc") eq "") {
        do_alter("user", "ALTER TABLE user ".
                 "ADD oldenc TINYINT DEFAULT 0 NOT NULL, ".
                 "MODIFY name CHAR(80) NOT NULL, ".
                 "DROP allow_getpromos");
    }

    # widen columns to accomodate larger Unicode names
    if (column_type("friendgroup", "groupname") eq "varchar(30)") {
        do_alter("friendgroup",
                 "ALTER TABLE friendgroup ".
                 "MODIFY groupname VARCHAR(60) NOT NULL");
    }
    if (column_type("todo", "statusline") eq "varchar(15)") {
        do_alter("todo",
                 "ALTER TABLE todo ".
                 "MODIFY statusline VARCHAR(40) NOT NULL, " .
                 "MODIFY subject VARCHAR(100) NOT NULL, " .
                 "MODIFY des VARCHAR(255) NOT NULL");
    }
    if (column_type("memorable", "des") eq "varchar(60)") {
        do_alter("memorable",
                 "ALTER TABLE memorable ".
                 "MODIFY des VARCHAR(150) NOT NULL");
    }
    if (column_type("keywords", "keyword") eq "varchar(40) binary") {
        do_alter("keywords",
                 "ALTER TABLE keywords ".
                 "MODIFY keyword VARCHAR(80) BINARY NOT NULL");
    }

    # change interest.interest key to being unique, if it's not already
    {
        my $sth = $dbh->prepare("SHOW INDEX FROM interests");
        $sth->execute;
        while (my $i = $sth->fetchrow_hashref) {
            if ($i->{'Key_name'} eq "interest" && $i->{'Non_unique'}) {
                do_alter("interests", "ALTER IGNORE TABLE interests ".
                         "DROP INDEX interest, ADD UNIQUE interest (interest)");
                last;
            }
        }
    }

});


1; # return true;

