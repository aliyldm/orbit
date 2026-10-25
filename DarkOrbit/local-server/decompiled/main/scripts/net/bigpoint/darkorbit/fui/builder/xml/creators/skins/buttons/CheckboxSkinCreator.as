package net.bigpoint.darkorbit.fui.builder.xml.creators.skins.buttons
{
   import net.bigpoint.darkorbit.fui.builder.xml.creators.skins.AbstractSkinCreator;
   import net.bigpoint.darkorbit.fui.components.buttons.checkbox.CheckBoxSkin;
   import net.bigpoint.darkorbit.fui.components.core.skins.ISkin;
   
   public class CheckboxSkinCreator extends AbstractSkinCreator
   {
      
      public function CheckboxSkinCreator()
      {
         super();
      }
      
      override public function create(param1:XML) : ISkin
      {
         var _loc2_:CheckBoxSkin = new CheckBoxSkin();
         assignTextStyleStates(param1,_loc2_);
         assignSkinStates(param1,_loc2_);
         return _loc2_;
      }
   }
}

