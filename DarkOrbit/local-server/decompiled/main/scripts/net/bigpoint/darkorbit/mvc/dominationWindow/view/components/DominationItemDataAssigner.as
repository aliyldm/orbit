package net.bigpoint.darkorbit.mvc.dominationWindow.view.components
{
   import com.bigpoint.utils.TextFormatter;
   import net.bigpoint.darkorbit.fui.builder.repository.SkinRepository;
   import net.bigpoint.darkorbit.fui.components.bars.ProgressBar;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.mvc.dominationWindow.DominationWindowConstants;
   import net.bigpoint.darkorbit.mvc.dominationWindow.model.vo.DominationBarVO;
   
   public class DominationItemDataAssigner extends DefaultItemDataAssigner
   {
      
      private static const _skinMap:Object = getSkinMap();
      
      private var _companyImg:Coreponent;
      
      private var _score:Label;
      
      private var _progressBar:ProgressBar;
      
      public function DominationItemDataAssigner()
      {
         super();
      }
      
      private static function getSkinMap() : Object
      {
         var _loc1_:Object = {};
         _loc1_[DominationWindowConstants.MMO + String(true)] = DominationWindowConstants.COMPANY_PROGRESS_BAR_SKIN_NAME_MMO_LEADING;
         _loc1_[DominationWindowConstants.VRU + String(true)] = DominationWindowConstants.COMPANY_PROGRESS_BAR_SKIN_NAME_VRU_LEADING;
         _loc1_[DominationWindowConstants.EIC + String(true)] = DominationWindowConstants.COMPANY_PROGRESS_BAR_SKIN_NAME_EIC_LEADING;
         _loc1_[DominationWindowConstants.MMO + String(false)] = DominationWindowConstants.COMPANY_PROGRESS_BAR_SKIN_NAME_MMO;
         _loc1_[DominationWindowConstants.VRU + String(false)] = DominationWindowConstants.COMPANY_PROGRESS_BAR_SKIN_NAME_VRU;
         _loc1_[DominationWindowConstants.EIC + String(false)] = DominationWindowConstants.COMPANY_PROGRESS_BAR_SKIN_NAME_EIC;
         return _loc1_;
      }
      
      override public function set data(param1:Object) : void
      {
         this.update(param1);
      }
      
      private function update(param1:Object) : void
      {
         var _loc2_:DominationBarVO = param1 as DominationBarVO;
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
      
      private function getSkinName(param1:DominationBarVO) : String
      {
         return _skinMap[param1.faction + param1.isLeading.toString()];
      }
      
      override public function assignChildren() : void
      {
         var _loc1_:Container = getChildByName(DominationWindowConstants.ITEMRENDERER_CONTAINER) as Container;
         this._companyImg = _loc1_.getChildByName(DominationWindowConstants.ITEM_COMPANY_IMAGE) as Coreponent;
         this._score = _loc1_.getChildByName(DominationWindowConstants.ITEM_SCORE) as Label;
         this._progressBar = _loc1_.getChildByName(DominationWindowConstants.ITEM_PROGRESS) as ProgressBar;
      }
   }
}

