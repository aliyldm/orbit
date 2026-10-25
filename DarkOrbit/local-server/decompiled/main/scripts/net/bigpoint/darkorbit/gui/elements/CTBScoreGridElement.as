package net.bigpoint.darkorbit.gui.elements
{
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   
   public class CTBScoreGridElement extends SimpleElement
   {
      
      public function CTBScoreGridElement()
      {
         super(TYPE_CTB_SCORE_GRID);
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         this.addChild(_loc1_.getEmbeddedBitmap("ctb_table"));
      }
   }
}

