package net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class AmmoOutputVO extends OutputVO
   {
      
      public static const TYPE_MCB_25:int = 1;
      
      public static const TYPE_MCB_50:int = 2;
      
      public static const TYPE_UCB_100:int = 4;
      
      public static const TYPE_ABS:int = 8;
      
      public static const TYPE_ROCKET_PLT_2121:int = 16;
      
      public static const TYPE_MINE_ACM_1:int = 32;
      
      private var _type:int;
      
      public function AmmoOutputVO(param1:int, param2:int, param3:Date)
      {
         super(OutputVO.CAT_AMMUNITION,param1,param3);
         this._type = param2;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set type(param1:int) : void
      {
         this._type = param1;
      }
      
      override public function toString() : String
      {
         var _loc1_:String = "";
         var _loc2_:String = "";
         switch(this._type)
         {
            case AmmoOutputVO.TYPE_MCB_25:
               _loc1_ = "log_entry_laser";
               _loc2_ = "MCB-25";
               break;
            case AmmoOutputVO.TYPE_MCB_50:
               _loc1_ = "log_entry_laser";
               _loc2_ = "MCB-50";
               break;
            case AmmoOutputVO.TYPE_UCB_100:
               _loc1_ = "log_entry_laser";
               _loc2_ = "UCB-100";
               break;
            case AmmoOutputVO.TYPE_ABS:
               _loc1_ = "log_entry_laser";
               _loc2_ = "SAB";
               break;
            case AmmoOutputVO.TYPE_ROCKET_PLT_2121:
               _loc1_ = "log_entry_rocket";
               _loc2_ = "PLT-2021";
               break;
            case AmmoOutputVO.TYPE_MINE_ACM_1:
               _loc1_ = "log_entry_mine_";
               if(_amount == 1)
               {
                  _loc1_ += "s";
               }
               else
               {
                  _loc1_ += "p";
               }
               _loc2_ = "ACM-01";
         }
         var _loc3_:String = BPLocale.getItemInCategory("galaxyGates",_loc1_);
         _loc3_ = _loc3_.replace(/%COUNT%/,BPLocale.formatNumber(_amount));
         return _loc3_.replace(/%TYPE%/,_loc2_);
      }
   }
}

