package net.bigpoint.darkorbit.net.netty.handlers.galaxygatebuilder
{
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderGateCompleteCommand;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.GalaxyGateBuilderProxy;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class GalaxyGateBuilderGateCompleteCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function GalaxyGateBuilderGateCompleteCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:GalaxyGateBuilderProxy = retrieveProxy(GuiConstants.GG_BUILDER_WINDOW) as GalaxyGateBuilderProxy;
         if(!_loc2_)
         {
            GuiManager.instance.createGGBuilderWindow();
            _loc2_ = retrieveProxy(GuiConstants.GG_BUILDER_WINDOW) as GalaxyGateBuilderProxy;
         }
         var _loc3_:GalaxyGateBuilderGateCompleteCommand = param1.getBody() as GalaxyGateBuilderGateCompleteCommand;
         _loc2_.handleGateComplete(_loc3_);
      }
   }
}

