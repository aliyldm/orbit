package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ShipDesignPack implements IModule
   {
      
      private static var _instance:ShipDesignPack;
      
      public var designList:Vector.<String>;
      
      public function ShipDesignPack(param1:Vector.<String> = null)
      {
         super();
         if(param1 == null)
         {
            this.designList = new Vector.<String>();
         }
         else
         {
            this.designList = param1;
         }
      }
      
      public static function get instance() : ShipDesignPack
      {
         return _instance || (_instance = new ShipDesignPack());
      }
      
      public function getLibcomModuleId() : int
      {
         return 25175;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.designList.length > 0)
         {
            this.designList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.designList.push(param1.readUTF());
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:String = null;
         param1.writeShort(25175);
         param1.writeByte(this.designList.length);
         for each(_loc2_ in this.designList)
         {
            param1.writeUTF(_loc2_);
         }
      }
   }
}

