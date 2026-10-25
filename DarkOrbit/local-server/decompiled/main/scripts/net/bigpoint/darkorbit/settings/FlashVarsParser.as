package net.bigpoint.darkorbit.settings
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.mvc.chatclient.model.backend.ChatSettings;
   
   public class FlashVarsParser
   {
      
      public function FlashVarsParser()
      {
         super();
      }
      
      public static function parseVars(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         for(_loc2_ in param1)
         {
            _loc3_ = String(param1[_loc2_]);
            switch(_loc2_)
            {
               case "host":
               case "dynamicHost":
                  Settings.dynamicHost = _loc3_ + "/";
                  break;
               case "userID":
                  Hero.userID = int(_loc3_);
                  break;
               case "factionID":
                  Hero.factionID.value = int(_loc3_);
                  break;
               case "sessionID":
                  Hero.sessionID = _loc3_;
                  break;
               case "useDeviceFonts":
                  Settings.useEmbeddedFonts = _loc3_ != "1";
                  break;
               case "mapID":
                  Settings.mapID = int(_loc3_);
                  break;
               case "basePath":
                  Settings.basePath = _loc3_;
                  if(Settings.basePath.charAt(Settings.basePath.length) != "/")
                  {
                     Settings.basePath += "/";
                  }
                  break;
               case "cdn":
                  Settings.staticHost = _loc3_;
                  break;
               case "resourceachievementsXmlHash":
                  Settings.achievementsResourceHash = _loc3_;
                  break;
               case "resourceEventsXmlHash":
                  Settings.eventsResourceHash = _loc3_;
                  break;
               case "resourceJumpGateXmlHash":
                  Settings.eventsResourceHash = _loc3_;
                  break;
               case "commandCenterXmlHash":
                  Settings.commandCenterHash = _loc3_;
                  break;
               case "lang":
                  Settings.language = _loc3_.split("_")[0];
                  break;
               case "pid":
               case "projectID":
                  Settings.instanceID = int(_loc3_);
                  break;
               case "boardLink":
                  Settings.boardLink = _loc3_;
                  break;
               case "helpLink":
                  Main.helpLink = _loc3_;
                  break;
               case "loadingClaim":
                  BPLocale.setItem("loadingClaim",decodeURIComponent(_loc3_));
                  break;
               case "localGS":
               case "localGs":
                  if(!(_loc3_.length == 0 || _loc3_ == "0"))
                  {
                     if(_loc3_ != "1")
                     {
                        Settings.defaultGameServer = _loc3_;
                     }
                     else
                     {
                        Settings.defaultGameServer = "localhost";
                     }
                  }
                  break;
               case "chatHost":
                  ChatSettings.server = _loc3_;
                  ChatSettings.chat_cross_ip = ChatSettings.addressNoPort;
                  break;
               case "autoStartEnabled":
               case "autostartEnabled":
                  Settings.singleSessionAutoStartEnabled = Boolean(int(_loc3_));
                  break;
               case "allowChat":
                  Settings.createChat = Boolean(int(_loc3_));
                  break;
               case "showAdvertisingHint":
                  Settings.advertisingHintEnabled = Boolean(int(_loc3_));
                  break;
               case "browser":
                  Settings.browser = _loc3_;
                  break;
               case "profileXmlHash":
                  Settings.profileXMLHash = _loc3_;
                  break;
               case "gameXmlHash":
                  Settings.gameXMLHash = _loc3_;
                  break;
               case "resourcesXmlHash":
                  Settings.resourceXMLHash = _loc3_;
                  break;
               case "resources3dXmlHash":
                  Settings.resources3dXmlHash = _loc3_;
                  break;
               case "resources3dparticlesXmlHash":
                  Settings.resources3dparticlesXmlHash = _loc3_;
                  break;
               case "itemXmlHash":
                  Settings.itemXMLHash = _loc3_;
                  break;
               case "eventStreamContext":
                  Settings.eventStreamContext = _loc3_;
                  break;
               case "languageXmlHash":
                  Settings.languageXMLHash = _loc3_;
                  break;
               case "display2d":
                  Settings.userType = int(_loc3_);
                  break;
               case "traceCom":
                  Settings.traceCom = Boolean(int(_loc3_));
                  break;
               case "sharedImages":
                  Settings.sharedImagesHost = _loc3_;
                  break;
               case "crossdomainHash":
                  Settings.crossdomainHash = _loc3_;
                  break;
               case "platform":
                  Settings.platform = _loc3_;
            }
         }
      }
   }
}

