package net.bigpoint.darkorbit.fui.builder.xml.creators.skins
{
   import net.bigpoint.darkorbit.fui.components.core.skins.BasicSkin;
   import net.bigpoint.darkorbit.fui.components.core.skins.ISkin;
   
   public class ContainerSkinCreator extends AbstractSkinCreator
   {
      
      public function ContainerSkinCreator()
      {
         super();
      }
      
      override public function create(param1:XML) : ISkin
      {
         var _loc2_:ISkin = new BasicSkin();
         assignSkinStates(param1,_loc2_);
         return _loc2_;
      }
   }
}

