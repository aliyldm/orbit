package net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class SpecialOutputVO extends OutputVO
   {
      
      public static const TYPE_HYPER_HITPOINT:int = 1;
      
      public static const TYPE_NANOHULL:int = 2;
      
      private var _type:int;
      
      public function SpecialOutputVO(param1:int, param2:int, param3:Date)
      {
         super(OutputVO.CAT_SPECIAL,param1,param3);
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
         switch(this._type)
         {
            case SpecialOutputVO.TYPE_HYPER_HITPOINT:
               _loc1_ = "log_entry_hp";
               break;
            case SpecialOutputVO.TYPE_NANOHULL:
               _loc1_ = "log_entry_nanohull";
         }
         return BPLocale.getItemInCategory("galaxyGates",_loc1_).replace(/%COUNT%/,BPLocale.formatNumber(_amount));
      }
   }
}

