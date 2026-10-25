package net.bigpoint.darkorbit.com.module.porting.synthesis
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SynthesisItemRequest implements IModule
   {
      
      private static var _instance:SynthesisItemRequest;
      
      public var synthesisId:String = "";
      
      public var itemIds:Vector.<Number>;
      
      public function SynthesisItemRequest(param1:String = "", param2:Vector.<Number> = null)
      {
         super();
         this.synthesisId = param1;
         if(param2 == null)
         {
            this.itemIds = new Vector.<Number>();
         }
         else
         {
            this.itemIds = param2;
         }
      }
      
      public static function get instance() : SynthesisItemRequest
      {
         return _instance || (_instance = new SynthesisItemRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -722;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.synthesisId = param1.readUTF();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.itemIds.length > 0)
         {
            this.itemIds.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.itemIds.push(param1.readDouble());
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:Number = NaN;
         param1.writeShort(-722);
         param1.writeUTF(this.synthesisId);
         param1.writeByte(this.itemIds.length);
         for each(_loc2_ in this.itemIds)
         {
            param1.writeDouble(_loc2_);
         }
      }
   }
}

