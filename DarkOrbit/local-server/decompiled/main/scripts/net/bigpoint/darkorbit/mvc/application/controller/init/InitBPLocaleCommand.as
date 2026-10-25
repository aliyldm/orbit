package net.bigpoint.darkorbit.mvc.application.controller.init
{
   import com.bigpoint.utils.TextFormatter;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.bplocale.BPLocaleEvent;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.bplocal.BPLocalLoadVO;
   import net.bigpoint.darkorbit.bplocal.BPLocalLoader;
   import net.bigpoint.darkorbit.bplocal.parser.BPLocaleParser4DO;
   import net.bigpoint.darkorbit.mvc.application.controller.DOAbstractLoadLanguagesAsyncCommand;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.eventstream.EventStreamClient;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class InitBPLocaleCommand extends DOAbstractLoadLanguagesAsyncCommand
   {
      
      public function InitBPLocaleCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:URLLoader = new URLLoader();
         _loc2_.addEventListener(Event.COMPLETE,this.handleHashFileLoaded);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
         _loc2_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         var _loc3_:String = Settings.staticHost + "spacemap/templates/language_" + Settings.language + ".xml?__cv=" + Settings.languageXMLHash;
         _loc2_.load(new URLRequest(_loc3_));
      }
      
      private function onError(param1:IOErrorEvent) : void
      {
         EventStreamClient.track("flash.debug InitBPLocaleCommand onError " + param1.toString());
      }
      
      private function onSecurityError(param1:SecurityErrorEvent) : void
      {
         EventStreamClient.track("flash.debug InitBPLocaleCommand onSecurityError " + param1.toString());
      }
      
      private function handleHashFileLoaded(param1:Event) : void
      {
         var _loc5_:XML = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc16_:String = null;
         var _loc17_:String = null;
         var _loc18_:String = null;
         var _loc19_:String = null;
         var _loc20_:String = null;
         var _loc21_:String = null;
         var _loc2_:URLLoader = param1.target as URLLoader;
         _loc2_.removeEventListener(Event.COMPLETE,this.handleHashFileLoaded);
         var _loc3_:XMLList = XML(_loc2_.data).children();
         var _loc4_:Dictionary = new Dictionary();
         for each(_loc5_ in _loc3_)
         {
            _loc4_[_loc5_.attribute("name").toString()] = _loc5_.attribute("hash").toString();
         }
         _loc6_ = Settings.language;
         _loc7_ = Settings.staticHost + "spacemap/templates/" + _loc6_ + "/";
         _loc8_ = _loc7_ + "flashres.xml?__cv=" + _loc4_["flashres"];
         _loc9_ = _loc7_ + "resource_quest.xml?__cv=" + _loc4_["resource_quest"];
         _loc10_ = _loc7_ + "resource_items.xml?__cv=" + _loc4_["resource_items"];
         _loc11_ = _loc7_ + "resource_achievement.xml?__cv=" + _loc4_["resource_achievement"];
         _loc12_ = _loc7_ + "resource_inventory.xml?__cv=" + _loc4_["resource_inventory"];
         _loc13_ = _loc7_ + "resource_eic.xml?__cv=" + _loc4_["resource_eic"];
         _loc14_ = _loc7_ + "resource_news.xml?__cv=" + _loc4_["resource_news"];
         _loc15_ = _loc7_ + "resource_galaxyGates.xml?__cv=" + _loc4_["resource_galaxyGates"];
         _loc16_ = _loc7_ + "resource_faq.xml?__cv=" + _loc4_["resource_faq"];
         _loc17_ = _loc7_ + "resource_inc.xml?__cv=" + _loc4_["resource_inc"];
         _loc18_ = _loc7_ + "resource.xml?__cv=" + _loc4_["resource"];
         BPLocale.addEventListener(BPLocaleEvent.NO_LANGUAGES_LEFT_TO_LOAD,this.handleBPLocaleLanguageLoaded);
         BPLocale.addEventListener(BPLocaleEvent.LANGUAGE_LOADING_ERROR,this.handleBPLocaleLanguageLoadingError);
         BPLocale.onFailMode = BPLocale.ON_FAIL_EVENT;
         _loc19_ = Settings.staticHost + "unityApi";
         _loc20_ = _loc19_ + "/events/spaceSearch.php";
         _loc21_ = _loc19_ + "/events/ssRewards.php";
         this.load(new <BPLocalLoadVO>[new BPLocalLoadVO(_loc8_,""),new BPLocalLoadVO(_loc9_,"quests"),new BPLocalLoadVO(_loc10_,"items"),new BPLocalLoadVO(_loc11_,"achievements"),new BPLocalLoadVO(_loc12_,"inventory"),new BPLocalLoadVO(_loc15_,"galaxyGates"),new BPLocalLoadVO(_loc16_,"faq"),new BPLocalLoadVO(_loc13_,"eic"),new BPLocalLoadVO(_loc17_,"inc"),new BPLocalLoadVO(_loc14_,"bn"),new BPLocalLoadVO(_loc18_,"base"),new BPLocalLoadVO(_loc20_,"events_space_search"),new BPLocalLoadVO(_loc21_,"events_space_search_rewards")]);
      }
      
      private function testLocaKeys(param1:String) : void
      {
         var _loc2_:URLLoader = new URLLoader();
         _loc2_.addEventListener(Event.COMPLETE,this.doTest);
         _loc2_.load(new URLRequest(param1));
      }
      
      private function doTest(param1:Event) : void
      {
         var _loc9_:XML = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc2_:URLLoader = param1.target as URLLoader;
         var _loc3_:XML = new XML(_loc2_.data);
         var _loc4_:XMLList = _loc3_.child("item");
         var _loc5_:Object = {};
         var _loc6_:Vector.<String> = new Vector.<String>(0);
         var _loc7_:int = _loc4_.length();
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc9_ = _loc4_[_loc8_];
            _loc10_ = String(_loc9_.attribute("name"));
            _loc11_ = String(_loc9_.attribute("name")) + "_mmo";
            _loc12_ = String(_loc9_.attribute("name")) + "_eic";
            _loc13_ = String(_loc9_.attribute("name")) + "_vru";
            if(Boolean(_loc5_[_loc10_]) || Boolean(_loc5_[_loc11_]) || Boolean(_loc5_[_loc12_]) || Boolean(_loc5_[_loc13_]))
            {
               if(_loc5_[_loc10_])
               {
                  _loc6_.push(_loc10_);
               }
               if(_loc5_[_loc11_])
               {
                  _loc6_.push(_loc11_);
               }
               if(_loc5_[_loc12_])
               {
                  _loc6_.push(_loc12_);
               }
               if(_loc5_[_loc13_])
               {
                  _loc6_.push(_loc13_);
               }
            }
            else
            {
               _loc5_[String(_loc9_.attribute("name"))] = true;
            }
            _loc8_++;
         }
      }
      
      private function load(param1:Vector.<BPLocalLoadVO>) : void
      {
         new BPLocalLoader().loaderMultipleURLs(param1,this.handleAllFilesLoaded);
      }
      
      private function handleAllFilesLoaded(param1:Vector.<XML>) : void
      {
         var _loc2_:int = int(param1.length);
         var _loc3_:BPLocaleParser4DO = new BPLocaleParser4DO();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_.parseXML(param1[_loc4_]);
            _loc4_++;
         }
         param1.length = 0;
         this.handleBPLocaleLanguageLoaded();
      }
      
      private function handleBPLocaleKeyNotFound(param1:BPLocaleEvent) : void
      {
      }
      
      private function handleBPLocaleCategoryNotFound(param1:BPLocaleEvent) : void
      {
      }
      
      private function handleBPLocaleLanguageLoadingError(param1:BPLocaleEvent) : void
      {
         this.commandComplete();
      }
      
      protected function handleBPLocaleLanguageLoaded(param1:BPLocaleEvent = null) : void
      {
         BPLocale.removeEventListener(BPLocaleEvent.NO_LANGUAGES_LEFT_TO_LOAD,this.handleBPLocaleLanguageLoaded);
         TextFormatter.setNumberSeparators();
         this.hackIntoLocale();
         this.commandComplete();
      }
      
      private function hackIntoLocale() : void
      {
         var _loc1_:String = BPLocale.getItem("no_clan");
         Hero.clanTag = _loc1_;
         Hero.NO_CLAN_LOCA = _loc1_;
         BPLocale.setItemInCategory("items","items_ammunition_mine_smb-01_fullname","SMB-01");
         BPLocale.setItemInCategory("items","items_ammunition_mine_smb-01_fullname","SMB-01");
         BPLocale.setItemInCategory("items","items_ammunition_mine_smb-01_fullname","SMB-01");
         BPLocale.setItemInCategory("items","items_ammunition_mine_smb-01_fullname","SMB-01");
         BPLocale.setItemInCategory("items","items_ammunition_mine_smb-01_fullname","SMB-01");
         BPLocale.setItemInCategory("items","items_ammunition_mine_smb-01_fullname","SMB-01");
         BPLocale.setItemInCategory("items","items_ammunition_mine_smb-01_fullname","SMB-01");
         BPLocale.setItemInCategory("items","items_ammunition_mine_smb-01_fullname","SMB-01");
         BPLocale.setItemInCategory("items","items_ammunition_mine_smb-01_fullname","SMB-01");
         BPLocale.setItemInCategory("items","items_ammunition_mine_smb-01_fullname","SMB-01");
         BPLocale.setItemInCategory("items","items_ammunition_mine_smb-01_fullname","SMB-01");
         BPLocale.setItemInCategory("items","items_ammunition_mine_smb-01_fullname","SMB-01");
         BPLocale.setItemInCategory("items","items_ammunition_mine_smb-01_fullname","SMB-01");
         BPLocale.setItemInCategory("items","items_ammunition_mine_smb-01_fullname","SMB-01");
         BPLocale.setItemInCategory("items","items_ammunition_mine_smb-01_fullname","SMB-01");
         BPLocale.setItemInCategory("items","items_ammunition_mine_smb-01_fullname","SMB-01");
         BPLocale.setItemInCategory("items","items_ammunition_mine_smb-01_fullname","SMB-01");
         BPLocale.setItemInCategory("items","items_ammunition_mine_smb-01_fullname","SMB-01");
         BPLocale.setItemInCategory("items","items_ammunition_mine_smb-01_fullname","SMB-01");
         BPLocale.setItemInCategory("items","items_ammunition_mine_smb-01_fullname","SMB-01");
         BPLocale.setItemInCategory("items","items_ammunition_mine_smb-01_fullname","SMB-01");
         BPLocale.setItem("equipment_weapon_rocketlauncher_hst","HST");
         BPLocale.setItem("loadingClaim","LOADING…");
         if(Settings.advertisingHintEnabled)
         {
            BPLocale.setItem("title_bannerad",BPLocale.getItem("title_bannerad") + " - " + BPLocale.getItem("title_bannerad_addendum"));
         }
         BPLocale.setItem("btn_label_bannerad_shipdesignGlory","Get it now for only %PRICE|SYMBOL%!");
         BPLocale.setItem("log_msg_gather_extra-energy_s",BPLocale.getItem("log_msg_gather_extra-energy_s_collected"));
         BPLocale.setItem("log_msg_gather_extra-energy_p",BPLocale.getItem("log_msg_gather_extra-energy_p_collected"));
         BPLocale.setItem("log_msg_gg_completed_y6",BPLocale.getItem("log_msg_gg_completed_bday"));
         BPLocale.setItem("title_107",BPLocale.getItem("title_337"));
         BPLocale.setItem("title_108",BPLocale.getItem("title_338"));
         BPLocale.setItem("title_109",BPLocale.getItem("title_339"));
         BPLocale.setItem("tutorial_video_msg_8_2",BPLocale.getItem("tutorial_video_msg_8_3"));
         BPLocale.setItem("tutorial_video_msg_9",BPLocale.getItem("tutorial_video_msg_8_3"));
         BPLocale.setItem("msg_station_built",BPLocale.getItem("msg_station_built_deflector_off"));
      }
   }
}

