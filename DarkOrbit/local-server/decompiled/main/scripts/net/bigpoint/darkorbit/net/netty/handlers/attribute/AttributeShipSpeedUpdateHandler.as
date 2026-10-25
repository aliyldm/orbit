package net.bigpoint.darkorbit.net.netty.handlers.attribute
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.AttributeShipSpeedUpdateCommand;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class AttributeShipSpeedUpdateHandler extends BaseHandler
   {
      
      public function AttributeShipSpeedUpdateHandler()
      {
         super();
      }
      
      public static function run(param1:AttributeShipSpeedUpdateCommand) : void
      {
         _main.getConnectionManager().getAttributeAssembly().assembleVelocityUpdate(param1.newSpeed);
         Hero.shownSpeed = param1.displaySpeed;
         _main.guiManager.updateInfoField(GuiConstants.SHIP_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_1,SimpleElement.TYPE_SPEED);
      }
   }
}

