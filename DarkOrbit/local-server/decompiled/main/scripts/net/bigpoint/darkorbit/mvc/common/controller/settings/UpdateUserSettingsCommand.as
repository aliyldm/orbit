package net.bigpoint.darkorbit.mvc.common.controller.settings
{
   import net.bigpoint.darkorbit.com.module.UserSettingsCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.net.netty.HandlerLookup;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class UpdateUserSettingsCommand extends DOAbstractSimpleCommand
   {
      
      public function UpdateUserSettingsCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:UserSettingsCommand = param1.getBody() as UserSettingsCommand;
         if(_loc2_)
         {
            HandlerLookup.execute(_loc2_.windowSettingsModule);
            if(!_loc2_.displaySettingsModule.notSet)
            {
               HandlerLookup.execute(_loc2_.displaySettingsModule);
            }
            else
            {
               guiManager.setDefaultDisplaySettings = true;
            }
            if(!_loc2_.audioSettingsModule.notSet)
            {
               HandlerLookup.execute(_loc2_.audioSettingsModule);
            }
            else
            {
               guiManager.setDefaultAudioSettings = true;
            }
            if(!_loc2_.gameplaySettingsModule.notSet)
            {
               HandlerLookup.execute(_loc2_.gameplaySettingsModule);
            }
            else
            {
               guiManager.setDefaultGameplaySettings = true;
            }
            if(!_loc2_.qualitySettingsModule.notSet)
            {
               HandlerLookup.execute(_loc2_.qualitySettingsModule);
            }
            else
            {
               guiManager.setDefaultQualitySettings = true;
            }
            if(_loc2_.questSettingsModule != null)
            {
               HandlerLookup.execute(_loc2_.questSettingsModule);
            }
            guiManager.createSettingsWindow();
         }
      }
   }
}

