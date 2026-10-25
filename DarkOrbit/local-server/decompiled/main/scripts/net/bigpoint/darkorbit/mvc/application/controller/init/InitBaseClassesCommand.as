package net.bigpoint.darkorbit.mvc.application.controller.init
{
   import com.greensock.plugins.ColorTransformPlugin;
   import com.greensock.plugins.DynamicPropsPlugin;
   import com.greensock.plugins.GlowFilterPlugin;
   import com.greensock.plugins.IDisplayObject.TransformAroundCenterPluginIDisplayObject;
   import com.greensock.plugins.IDisplayObject.TransformAroundPointPluginIDisplayObject;
   import com.greensock.plugins.TransformAroundCenterPlugin;
   import com.greensock.plugins.TweenPlugin;
   import com.greensock.plugins.factoryPlugins.DynamicPropsPluginFactory;
   import flash.display.Stage;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.managers.BaseManager;
   import net.bigpoint.darkorbit.managers.InfiltrationGameManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.application.model.vo.StartupVO;
   import net.bigpoint.darkorbit.net.BaseAssembly;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class InitBaseClassesCommand extends AsyncCommand
   {
      
      public function InitBaseClassesCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:StartupVO = param1.getBody() as StartupVO;
         this.initializeBaseClasses(_loc2_);
         commandComplete();
      }
      
      private function initializeBaseClasses(param1:StartupVO) : void
      {
         var _loc2_:Main = param1.main;
         var _loc3_:GameFacade = GameFacade.getInstance();
         var _loc4_:Stage = param1.stage;
         _loc4_.stageFocusRect = false;
         _loc4_.align = StageAlign.TOP_LEFT;
         _loc4_.scaleMode = StageScaleMode.NO_SCALE;
         _loc4_.frameRate = 60;
         BaseManager.setMain(_loc2_);
         ScreenManager.getInstance().init(_loc2_);
         BaseAssembly.setMain(_loc2_);
         BaseHandler.setMain(_loc2_);
         AudioManager.init(_loc2_);
         BaseHandler.setFacade(_loc3_);
         TweenPlugin.activate([TransformAroundCenterPlugin,ColorTransformPlugin,DynamicPropsPlugin,GlowFilterPlugin,TransformAroundCenterPluginIDisplayObject,TransformAroundPointPluginIDisplayObject,DynamicPropsPluginFactory]);
         _loc2_.screenManager = ScreenManager.getInstance();
         _loc2_.ifgManager = new InfiltrationGameManager(_loc2_);
      }
   }
}

