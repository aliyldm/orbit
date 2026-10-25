package net.bigpoint.darkorbit.fui.builder.xml.creators.skins
{
   import net.bigpoint.darkorbit.fui.components.core.skins.BasicStateSkin;
   import net.bigpoint.darkorbit.fui.components.core.skins.ISkin;
   
   public class ContainerStateSkinCreator extends AbstractSkinCreator
   {
      
      public function ContainerStateSkinCreator()
      {
         super();
      }
      
      override public function create(param1:XML) : ISkin
      {
         var _loc2_:ISkin = new BasicStateSkin();
         assignStateNames(param1,_loc2_);
         assignSkinStates(param1,_loc2_);
         return _loc2_;
      }
   }
}

