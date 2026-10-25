package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.minimap.traits.MiniMapDotTrait;
   
   public class MarkedByReconEffect extends MapObjectEffect
   {
      
      private static const TIMEOUT_TIME:int = 1500;
      
      private var _oldColor:uint;
      
      public function MarkedByReconEffect(param1:MapEntity)
      {
         super(EffectIDList.MARKED_BY_RECON_EFFECT,param1,TIME_OUT,null,InGameCatalog.SOUND_ID_SPEARHEAD_MARK_TARGET);
         timeOutTime = TIMEOUT_TIME;
      }
      
      override public function activate() : Boolean
      {
         super.activate();
         var _loc1_:MiniMapDotTrait = source.getFirstTrait(MiniMapDotTrait) as MiniMapDotTrait;
         if(_loc1_)
         {
            this._oldColor = _loc1_.color;
            _loc1_.color = 65280;
         }
         return super.activate();
      }
      
      override public function deactivate() : void
      {
         var _loc1_:MiniMapDotTrait = null;
         if(source)
         {
            _loc1_ = source.getFirstTrait(MiniMapDotTrait) as MiniMapDotTrait;
            if(_loc1_)
            {
               _loc1_.color = this._oldColor;
            }
         }
         super.deactivate();
      }
      
      override public function get ignoresCloak() : Boolean
      {
         return true;
      }
   }
}

