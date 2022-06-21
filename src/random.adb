
package body Random is

   function Shift_Right(Value : Number_Type; Count : Natural) return Number_Type
     with
       Import,
       Convention => Intrinsic;

   function Shift_Left(Value : Number_Type; Count : Natural) return Number_Type
     with
       Import,
       Convention => Intrinsic;


   function Next(G : in out Generator'Class; Low, High : Number_Type) return Number_Type is
      Current : Number_Type := Next(G);
   begin
      return (Current rem (High - Low + 1)) + Low;
   end Next;


   ---------------------
   -- Type Bit_Generator
   ---------------------

   function Make(G : access Generator'Class) return Bit_Generator is
   begin
      return (Underlying => G, Current_Value => 0, Mask => 0);
   end Make;

   function Maximum(B : in Bit_Generator) return Number_Type is
   begin
      return 1;
   end Maximum;

   function Next(B : in out Bit_Generator) return Number_Type is
      Bit : Number_Type;
   begin
      -- Generate a fresh number if necessary.
      if B.Mask = 0 then
         B.Current_Value := Next(B.Underlying.all);
         B.Mask := 1;
      end if;

      -- Examine the current bit.
      Bit := (if (B.Current_Value and B.Mask) /= 0 then 1 else 0);

      -- Advance the mask, taking care not to overflow.
      if B.Mask > Shift_Right(Number_Type'Last, 1) then
         B.Mask := 0;
      else
         B.Mask := Shift_Left(B.Mask, 1);
         if B.Mask > Maximum(B.Underlying.all) then
            B.Mask := 0;
         end if;
      end if;

      return Bit;
   end Next;


   ---------------------
   -- Type LSB_Generator
   ---------------------

   function Make(G : access Generator'Class) return LSB_Generator is
   begin
      return (Underlying => G);
   end Make;

   function Maximum(B : in LSB_Generator) return Number_Type is
   begin
      return 1;
   end Maximum;

   function Next(B : in out LSB_Generator) return Number_Type is
   begin
      return Next(B.Underlying.all) and 1;
   end Next;


   ---------------------------
   -- Type Linear_Congruential
   ---------------------------

   function Make return Linear_Congruential is
   begin
      return (Current_Value => 0);
   end Make;

   function Maximum(L : in Linear_Congruential) return Number_Type is
   begin
      return 1771875 - 1;
   end Maximum;

   function Next(L : in out Linear_Congruential) return Number_Type is
   begin
      L.Current_Value := ( (2416 * L.Current_Value) + 374441 ) rem 1771875;
      return L.Current_Value;
   end Next;

   procedure Seed(L : in out Linear_Congruential; Seed : in Number_Type) is
   begin
      L.Current_Value := Seed rem 1771875;
   end Seed;

end Random;
