package net.bigpoint.darkorbit.fui.builder.xml.creators.skins.text
{
   import net.bigpoint.darkorbit.fui.builder.xml.creators.skins.AbstractSkinCreator;
   import net.bigpoint.darkorbit.fui.components.core.skins.ISkin;
   import net.bigpoint.darkorbit.fui.components.text.label.LabelSkin;
   import net.bigpoint.darkorbit.fui.components.text.label.MarqueeLabelSkin;
   
   public class MarqueeLabelSkinCreator extends AbstractSkinCreator
   {
      
      public function MarqueeLabelSkinCreator()
      {
         super();
      }
      
      override public function create(param1:XML) : ISkin
      {
         var _loc2_:ISkin = new MarqueeLabelSkin();
         if(param1.attribute("truncateText") != undefined)
         {
            (_loc2_ as LabelSkin).truncateText = isBoolean(param1.attribute("truncateText"));
         }
         assignSkinStates(param1,_loc2_);
         registerSkin(param1,_loc2_);
         return _loc2_;
      }
   }
}

