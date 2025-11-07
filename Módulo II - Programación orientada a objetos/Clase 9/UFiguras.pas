unit UFiguras;
{$mode objfpc}
interface
    const
        pi = 3.1415926;
    type
        Figura = class
            public
                function getArea() : real; virtual; abstract;
                function getPerimetro() : real; virtual; abstract;
                function toString() : ansistring; override;
        end;
        Cuadrado = class(Figura)
            private
                lado : real;
            public
                constructor create(longitudLado : real);
                function getArea() : real; override;
                function getPerimetro() : real; override;
        end;
        Circulo = class(Figura)
            private
                radio : real;
            public
                constructor create(r : real);
                function getArea() : real; override;
                function getPerimetro() : real; override;
        end;
        Triangulo = class(Figura)
            private
                lado1, lado2, lado3 : real;
            public
                constructor create(l1, l2, l3 : real);
                function getArea() : real; override;
                function getPerimetro() : real; override;   
        end;
implementation
uses SysUtils;
    function Figura.toString() : ansistring;
    var
        area, perimetro : real;
    begin
        area := self.getArea(); perimetro := self.getPerimetro();
        toString := format('%8.2f - %8.2f', [area, perimetro]);
    end;

    constructor Cuadrado.create(longitudLado : real);
    begin
        lado := longitudLado;
    end;
    function Cuadrado.getArea() : real;
    begin
        getArea := lado*lado;
    end;
    function Cuadrado.getPerimetro() : real;
    begin
        getPerimetro := lado * 4;
    end;
    
    constructor Circulo.create(r : real);
    begin
        radio := r;
    end;
    function Circulo.getArea() : real;
    begin
        getArea := pi*radio*radio;
    end;
    function Circulo.getPerimetro() : real;
    begin
        getPerimetro := 2 * pi * radio;
    end;

    constructor Triangulo.create(l1, l2, l3 : real);
    begin
        lado1 := l1; lado2 := l2; lado3 := l3;
    end;
    function Triangulo.getPerimetro() : real;
    begin
        getPerimetro := lado1 + lado2 + lado3;
    end;
    function Triangulo.getArea() : real;
    var
        s : real;
    begin
        s := (self.getPerimetro() / 2);
        getArea := (sqrt(s*(s-lado1)*(s-lado2)*(s-lado3)));
    end;
end.