package net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class PartOutputVO extends OutputVO
   {
      
      private var _part_id:int;
      
      private var _gate_id:int;
      
      private var _duplicate:int;
      
      public function PartOutputVO(param1:Date, param2:int, param3:int, param4:int = 0)
      {
         super(OutputVO.CAT_PART,1,param1);
         this._part_id = param2;
         this._gate_id = param3;
         this._duplicate = param4;
      }
      
      override public function toString() : String
      {
         return BPLocale.getItemInCategory("galaxyGates","log_entry_part").replace(/%PART_ID%/,this._part_id).replace(/%GATE_NAME%/,BPLocale.getItemInCategory("galaxyGates","gate_name_" + this._gate_id));
      }
      
      public function get part_id() : int
      {
         return this._part_id;
      }
      
      public function set part_id(param1:int) : void
      {
         this._part_id = param1;
      }
      
      public function get gate_id() : int
      {
         return this._gate_id;
      }
      
      public function set gate_id(param1:int) : void
      {
         this._gate_id = param1;
      }
      
      public function get duplicate() : int
      {
         return this._duplicate;
      }
      
      public function set duplicate(param1:int) : void
      {
         this._duplicate = param1;
      }
   }
}

