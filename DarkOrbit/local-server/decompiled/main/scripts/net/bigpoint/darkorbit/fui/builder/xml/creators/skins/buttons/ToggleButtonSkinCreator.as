package net.bigpoint.darkorbit.fui.builder.xml.creators.skins.buttons
{
   import net.bigpoint.darkorbit.fui.builder.xml.creators.skins.AbstractSkinCreator;
   import net.bigpoint.darkorbit.fui.components.buttons.toggle.ToggleButtonSkin;
   import net.bigpoint.darkorbit.fui.components.core.skins.ISkin;
   
   public class ToggleButtonSkinCreator extends AbstractSkinCreator
   {
      
      public function ToggleButtonSkinCreator()
      {
         super();
      }
      
      override public function create(param1:XML) : ISkin
      {
         var _loc2_:ToggleButtonSkin = new ToggleButtonSkin();
         assignSkinStates(param1,_loc2_);
         return _loc2_;
      }
   }
}

