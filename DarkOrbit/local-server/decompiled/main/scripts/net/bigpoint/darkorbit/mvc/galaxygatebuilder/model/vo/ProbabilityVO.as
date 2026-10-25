package net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo
{
   public class ProbabilityVO
   {
      
      public static const CAT_AMMUNITION:String = "ammo";
      
      public static const CAT_RESOURCE:String = "resource";
      
      public static const CAT_VOUCHER:String = "voucher";
      
      public static const CAT_PART:String = "part";
      
      public static const CAT_SPECIAL:String = "nanohull";
      
      public static const CAT_LOGFILES:String = "logfiles";
      
      public static const INDEX_AMMUNITION:int = 0;
      
      public static const INDEX_RESOURCE:int = 1;
      
      public static const INDEX_VOUCHER:int = 2;
      
      public static const INDEX_PART:int = 3;
      
      public static const INDEX_SPECIAL:int = 4;
      
      public static const INDEX_LOGFILES:int = 5;
      
      public static const INDEX_LENGTH:int = 6;
      
      private var _data:Array;
      
      public function ProbabilityVO()
      {
         super();
         this._data = new Array({
            "pct":0,
            "bg":CAT_AMMUNITION,
            "icon":"ammo",
            "trans_key":"output_category_ammunition"
         },{
            "pct":0,
            "bg":CAT_RESOURCE,
            "icon":"xenomit",
            "trans_key":"output_category_xenomit"
         },{
            "pct":0,
            "bg":CAT_VOUCHER,
            "icon":"voucher",
            "trans_key":"output_category_voucher"
         },{
            "pct":0,
            "bg":CAT_PART,
            "icon":"part",
            "trans_key":"output_category_part"
         },{
            "pct":0,
            "bg":CAT_SPECIAL,
            "icon":"nanohull",
            "trans_key":"output_category_nanohull"
         },{
            "pct":0,
            "bg":CAT_LOGFILES,
            "icon":"logfiles",
            "trans_key":"output_category_logfiles"
         });
      }
      
      public function setProbability(param1:int, param2:int) : void
      {
         if(param1 > -1 && param1 < INDEX_LENGTH && param2 > 0 && param2 < 101)
         {
            this._data[param1]["pct"] = param2;
         }
      }
      
      public function get data() : Array
      {
         return this._data;
      }
   }
}

