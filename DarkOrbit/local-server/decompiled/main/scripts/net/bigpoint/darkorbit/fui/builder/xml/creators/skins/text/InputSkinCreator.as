package net.bigpoint.darkorbit.fui.builder.xml.creators.skins.text
{
   import net.bigpoint.darkorbit.fui.builder.xml.creators.skins.AbstractSkinCreator;
   import net.bigpoint.darkorbit.fui.components.core.skins.ISkin;
   import net.bigpoint.darkorbit.fui.components.text.input.InputSkin;
   
   public class InputSkinCreator extends AbstractSkinCreator
   {
      
      public function InputSkinCreator()
      {
         super();
      }
      
      override public function create(param1:XML) : ISkin
      {
         var _loc2_:ISkin = new InputSkin();
         assignSkinStates(param1,_loc2_);
         return _loc2_;
      }
   }
}

