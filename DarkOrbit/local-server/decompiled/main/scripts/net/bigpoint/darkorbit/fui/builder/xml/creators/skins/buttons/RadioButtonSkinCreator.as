package net.bigpoint.darkorbit.fui.builder.xml.creators.skins.buttons
{
   import net.bigpoint.darkorbit.fui.builder.xml.creators.skins.AbstractSkinCreator;
   import net.bigpoint.darkorbit.fui.components.buttons.radio.RadioButtonSkin;
   import net.bigpoint.darkorbit.fui.components.core.skins.ISkin;
   
   public class RadioButtonSkinCreator extends AbstractSkinCreator
   {
      
      public function RadioButtonSkinCreator()
      {
         super();
      }
      
      override public function create(param1:XML) : ISkin
      {
         var _loc2_:RadioButtonSkin = new RadioButtonSkin();
         assignTextStyleStates(param1,_loc2_);
         assignSkinStates(param1,_loc2_);
         return _loc2_;
      }
   }
}

