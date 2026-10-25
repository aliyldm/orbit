package net.bigpoint.darkorbit.mvc.influenceWindow.model
{
   import net.bigpoint.darkorbit.mvc.influenceWindow.InfluenceWindowConsts;
   
   public class InfluenceModel
   {
      
      private var _playerScore:Number = 0;
      
      private var _maxScore:Number = 0;
      
      private var _mmoVo:InfluenceBarVo = new InfluenceBarVo(InfluenceWindowConsts.MMO,0,0,true);
      
      private var _eicVo:InfluenceBarVo = new InfluenceBarVo(InfluenceWindowConsts.EIC,0,0,false);
      
      private var _vruVo:InfluenceBarVo = new InfluenceBarVo(InfluenceWindowConsts.VRU,0,0,false);
      
      private var _list:Vector.<InfluenceBarVo> = new <InfluenceBarVo>[this._mmoVo,this._eicVo,this._vruVo];
      
      public function InfluenceModel()
      {
         super();
      }
      
      public function set playerScore(param1:Number) : void
      {
         this._playerScore = param1;
      }
      
      public function get playerScore() : Number
      {
         return this._playerScore;
      }
      
      public function set mmoScore(param1:Number) : void
      {
         this._mmoVo.score = param1;
         this.calcMaxValue();
         this.setLeader();
      }
      
      private function setLeader() : void
      {
         var _loc1_:InfluenceBarVo = null;
         for each(_loc1_ in this._list)
         {
            _loc1_.isLeading = _loc1_.score == this._maxScore;
         }
      }
      
      private function calcMaxValue() : void
      {
         var _loc1_:InfluenceBarVo = null;
         this._maxScore = Math.max(this._mmoVo.score,this._eicVo.score,this._vruVo.score);
         for each(_loc1_ in this._list)
         {
            _loc1_.maxScore = this._maxScore;
         }
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
      
      public function get maxScore() : Number
      {
         return this._maxScore;
      }
      
      public function get list() : Vector.<InfluenceBarVo>
      {
         return this._list;
      }
   }
}

