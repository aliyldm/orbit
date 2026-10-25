package net.bigpoint.darkorbit.mvc.application.controller.init
{
   import flash.display.LoaderInfo;
   import flash.display.Stage;
   import flash.external.ExternalInterface;
   import flash.system.Security;
   import net.bigpoint.darkorbit.EmbeddedFonts;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.mvc.application.model.vo.StartupVO;
   import net.bigpoint.darkorbit.mvc.gui.messages.model.vo.InstantLogViewConfigurationVO;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   import net.bigpoint.darkorbit.settings.FlashVarsParser;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class InitFlashVarsCommand extends AsyncCommand
   {
      
      public function InitFlashVarsCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:StartupVO = param1.getBody() as StartupVO;
         this.init(_loc2_);
      }
      
      private function init(param1:StartupVO) : void
      {
         this.parseFlashvars(param1.stage);
         if(Settings.useEmbeddedFonts)
         {
            EmbeddedFonts.initialize();
         }
         else
         {
            Styles.useDeviceFonts();
         }
         commandComplete();
      }
      
      private function parseFlashvars(param1:Stage) : void
      {
         var flashvars:Object = null;
         var stage:Stage = param1;
         try
         {
            flashvars = LoaderInfo(stage.loaderInfo).parameters;
            FlashVarsParser.parseVars(flashvars);
            Security.loadPolicyFile(Settings.dynamicHost + "crossdomain.xml?_cv=" + Settings.crossdomainHash);
            if(Settings.staticHost != null && Settings.staticHost.length > 0)
            {
               Security.allowDomain(Settings.staticHost);
            }
            else
            {
               Settings.staticHost = Settings.dynamicHost;
            }
            Settings.instantLogViewConfig = new InstantLogViewConfigurationVO();
            Security.allowDomain(Settings.dynamicHost);
            Security.allowDomain("*");
            if(ExternalInterface.available)
            {
               Settings.isPepperFlashPlayer = ExternalInterface.call(JavascriptProxy.FUNCTION_IS_PEPPER_PLAYER) as Boolean;
            }
         }
         catch(error:Error)
         {
         }
      }
   }
}

