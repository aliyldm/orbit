package net.bigpoint.darkorbit.mvc.influenceWindow.view
{
   import com.bigpoint.utils.TextFormatter;
   import net.bigpoint.darkorbit.fui.builder.repository.SkinRepository;
   import net.bigpoint.darkorbit.fui.components.bars.ProgressBar;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.mvc.influenceWindow.InfluenceWindowConsts;
   import net.bigpoint.darkorbit.mvc.influenceWindow.model.InfluenceBarVo;
   
   public class InfluenceItemDataAsigner extends DefaultItemDataAssigner
   {
      
      private static const _skinMap:Object = getSkinMap();
      
      private var _companyImg:Coreponent;
      
      private var _score:Label;
      
      private var _progressBar:ProgressBar;
      
      public function InfluenceItemDataAsigner()
      {
         super();
      }
      
      private static function getSkinMap() : Object
      {
         var _loc1_:Object = {};
         _loc1_[InfluenceWindowConsts.MMO + String(true)] = InfluenceWindowConsts.COMPANY_PROGRESS_BAR_SKIN_NAME_MMO_LEADING;
         _loc1_[InfluenceWindowConsts.VRU + String(true)] = InfluenceWindowConsts.COMPANY_PROGRESS_BAR_SKIN_NAME_VRU_LEADING;
         _loc1_[InfluenceWindowConsts.EIC + String(true)] = InfluenceWindowConsts.COMPANY_PROGRESS_BAR_SKIN_NAME_EIC_LEADING;
         _loc1_[InfluenceWindowConsts.MMO + String(false)] = InfluenceWindowConsts.COMPANY_PROGRESS_BAR_SKIN_NAME_MMO;
         _loc1_[InfluenceWindowConsts.VRU + String(false)] = InfluenceWindowConsts.COMPANY_PROGRESS_BAR_SKIN_NAME_VRU;
         _loc1_[InfluenceWindowConsts.EIC + String(false)] = InfluenceWindowConsts.COMPANY_PROGRESS_BAR_SKIN_NAME_EIC;
         return _loc1_;
      }
      
      override public function set data(param1:Object) : void
      {
         this.update(param1);
      }
      
      private function update(param1:Object) : void
      {
         var _loc2_:InfluenceBarVo = param1 as InfluenceBarVo;
         this._score.text = TextFormatter.round(_loc2_.score);
         this._companyImg.setSkinState(_loc2_.faction);
         var _loc3_:String = this.getSkinName(_loc2_);
         if(this._progressBar.skin.registerdName != _loc3_)
         {
            this._progressBar.skin = SkinRepository.getInstance().getSkin(_loc3_);
         }
         this._progressBar.forceRedraw(InvalidationType.SKIN);
         this._progressBar.maxValue = _loc2_.maxScore;
         this._progressBar.currentValue = _loc2_.score;
      }
      
      private function getSkinName(param1:InfluenceBarVo) : String
      {
         return _skinMap[param1.faction + param1.isLeading.toString()];
      }
      
      override public function assignChildren() : void
      {
         var _loc1_:Container = getChildByName(InfluenceWindowConsts.ITEM_RENDERER_CONTAINER_KEY) as Container;
         this._companyImg = _loc1_.getChildByName(InfluenceWindowConsts.COMPANY_IMAGE_KEY) as Coreponent;
         this._score = _loc1_.getChildByName(InfluenceWindowConsts.COMPANY_SCORE_LABEL_KEY) as Label;
         this._progressBar = _loc1_.getChildByName(InfluenceWindowConsts.COMPANY_PROGRESS_BAR_KEY) as ProgressBar;
      }
   }
}

