package net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo
{
   public class CleanedOutputVO
   {
      
      private var _distilledLabel:String;
      
      private var _useTooltip:Boolean;
      
      private var _fullText:String;
      
      public function CleanedOutputVO(param1:String, param2:Boolean = false, param3:String = "default")
      {
         super();
         this._distilledLabel = param1;
         this._useTooltip = param2;
         this._fullText = param3;
      }
      
      public function get distilledLabel() : String
      {
         return this._distilledLabel;
      }
      
      public function get useTooltip() : Boolean
      {
         return this._useTooltip;
      }
      
      public function get fullText() : String
      {
         return this._fullText;
      }
   }
}

