package net.bigpoint.darkorbit.mvc.application.controller.init
{
   import net.bigpoint.darkorbit.mvc.application.model.ProfileProxy;
   import net.bigpoint.darkorbit.mvc.application.model.vo.StartupVO;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class InitProfileModelCommand extends AsyncCommand
   {
      
      public function InitProfileModelCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:String = Settings.basePath + "xml/profile.xml?__cv=" + Settings.profileXMLHash;
         if(StartupVO(param1.getBody()).flashVars.resourcesPath != undefined)
         {
            _loc2_ = StartupVO(param1.getBody()).flashVars.resourcesPath + "xml/profile.xml?cv=";
         }
         var _loc3_:ProfileProxy = facade.retrieveProxy(ProfileProxy.NAME) as ProfileProxy;
         _loc3_.load(_loc2_,this.onProfileXMLLoadedAndParsed);
      }
      
      protected function onProfileXMLLoadedAndParsed() : void
      {
         this.commandComplete();
      }
   }
}

