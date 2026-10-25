package net.bigpoint.darkorbit.fui.builder.xml.utils
{
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.fui.builder.xml.creators.*;
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   import net.bigpoint.darkorbit.fui.system.utils.displayobject.DisplayObjectDefaultDecoration;
   
   public class CoreponentDecorator extends AbstractCreator
   {
      
      private const type2DecoratorMap:Dictionary = new Dictionary();
      
      public function CoreponentDecorator()
      {
         super();
         this.type2DecoratorMap["default.shadow"] = this.addShadow;
         this.type2DecoratorMap["default.lightBlueGlow"] = this.addLightBlueGlow;
         this.type2DecoratorMap["default.orangeGlowShadow"] = this.addOrangeGlowShadow;
      }
      
      public function decorate(param1:ICoreponent, param2:String) : void
      {
         var _loc3_:Function = this.type2DecoratorMap[param2];
         if(_loc3_ != null)
         {
            _loc3_(param1);
         }
      }
      
      private function addShadow(param1:ICoreponent) : void
      {
         DisplayObjectDefaultDecoration.setShadow(param1 as Sprite);
      }
      
      private function addLightBlueGlow(param1:ICoreponent) : void
      {
         DisplayObjectDefaultDecoration.addLightBlueGlow(param1 as Sprite);
      }
      
      private function addOrangeGlowShadow(param1:ICoreponent) : void
      {
         DisplayObjectDefaultDecoration.addOrangeGlowShadow(param1 as Sprite);
      }
   }
}

