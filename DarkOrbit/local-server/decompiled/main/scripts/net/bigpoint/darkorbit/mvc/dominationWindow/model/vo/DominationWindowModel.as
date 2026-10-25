package net.bigpoint.darkorbit.mvc.dominationWindow.model.vo
{
   import net.bigpoint.darkorbit.mvc.dominationWindow.DominationWindowConstants;
   
   public class DominationWindowModel
   {
      
      private var _mmoVo:DominationBarVO = new DominationBarVO(DominationWindowConstants.MMO,0,0,true);
      
      private var _eicVo:DominationBarVO = new DominationBarVO(DominationWindowConstants.EIC,0,0,false);
      
      private var _vruVo:DominationBarVO = new DominationBarVO(DominationWindowConstants.VRU,0,0,false);
      
      private var _list:Vector.<DominationBarVO> = new <DominationBarVO>[this._mmoVo,this._eicVo,this._vruVo];
      
      private var _dominationPoints:DominationPointsVO = new DominationPointsVO();
      
      public function DominationWindowModel()
      {
         super();
      }
      
      public function get list() : Vector.<DominationBarVO>
      {
         return this._list;
      }
      
      public function set mmoScore(param1:Number) : void
      {
         this._mmoVo.score = param1;
         this.calcMaxValue();
         this.setLeader();
      }
      
      public function set eicScore(param1:Number) : void
      {
         this._eicVo.score = param1;
         this.calcMaxValue();
         this.setLeader();
      }
      
      public function set vruScore(param1:Number) : void
      {
         this._vruVo.score = param1;
         this.calcMaxValue();
         this.setLeader();
      }
      
      private function setLeader() : void
      {
         var _loc1_:DominationBarVO = null;
         for each(_loc1_ in this._list)
         {
            _loc1_.isLeading = _loc1_.score == _loc1_.maxScore;
         }
      }
      
      private function calcMaxValue() : void
      {
         var _loc2_:DominationBarVO = null;
         var _loc1_:int = Math.max(this._mmoVo.score,this._eicVo.score,this._vruVo.score);
         for each(_loc2_ in this._list)
         {
            _loc2_.maxScore = _loc1_;
         }
      }
      
      public function get dominationPoints() : DominationPointsVO
      {
         return this._dominationPoints;
      }
   }
}

