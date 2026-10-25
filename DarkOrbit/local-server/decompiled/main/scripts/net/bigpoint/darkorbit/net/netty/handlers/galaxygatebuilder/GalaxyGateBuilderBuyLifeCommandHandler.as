package net.bigpoint.darkorbit.net.netty.handlers.galaxygatebuilder
{
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderBuyLifeCommand;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.GalaxyGateBuilderProxy;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class GalaxyGateBuilderBuyLifeCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function GalaxyGateBuilderBuyLifeCommandHandler()
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
         var _loc3_:GalaxyGateBuilderBuyLifeCommand = param1.getBody() as GalaxyGateBuilderBuyLifeCommand;
         _loc2_.handleGateLifePurchase(_loc3_);
      }
   }
}

