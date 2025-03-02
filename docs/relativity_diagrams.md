# Relativity Calculator Diagrams

This document contains diagrams that explain the structure and concepts of the LightBubble Relativity Calculator.

## Module Structure

```mermaid
classDiagram
    class Constants {
        +speed_of_light()
        +gravitational_constant()
        +planck_constant()
        +reduced_planck_constant()
    }

    class Spacetime {
        +minkowski_metric()
        +schwarzschild_metric(mass, r, theta, phi)
        +kerr_metric(mass, angular_momentum, r, theta)
        +morris_thorne_metric(throat_radius, r, theta)
        +flrw_metric(scale_factor, curvature, chi, theta)
        +proper_time_interval(metric, dx)
        +calculate_proper_time(velocity, mass, r, coordinate_time)
    }

    class TimeDilation {
        +calculate_special_relativistic_time(velocity, observer_time)
        +calculate_gravitational_time(mass, r, observer_time)
        +calculate_proper_time(velocity, mass, r, observer_time)
        +calculate_proper_time_with_metric(velocity_vector, metric_tensor, observer_time)
    }

    TimeDilation --> Constants : uses
    TimeDilation --> Spacetime : uses
    Spacetime --> Constants : uses
```

## Calculation Flow

```mermaid
flowchart TD
    A[User Input] --> B{Calculation Type}
    B -->|Special Relativity| C[Calculate Special Relativistic Time]
    B -->|Gravitational| D[Calculate Gravitational Time]
    B -->|Combined| E[Calculate Combined Time Dilation]
    B -->|Custom Metric| F[Calculate with Custom Metric]

    C --> G[Return Proper Time]
    D --> G
    E --> G
    F --> G

    C -.-> H[Uses Lorentz Factor]
    D -.-> I[Uses Schwarzschild Metric]
    E -.-> J[Uses Both Factors]
    F -.-> K[Uses Tensor Contraction]
```

## Special Relativity Time Dilation

```mermaid
flowchart LR
    A[Observer Time] --> B[Lorentz Factor Calculation]
    C[Velocity] --> B
    D[Speed of Light] --> B
    B --> E[Proper Time Calculation]
    E --> F[Proper Time]

    subgraph Lorentz Factor
    B
    end

    subgraph Formula
    G["γ = 1/√(1-v²/c²)"]
    H["Δt' = Δt/γ"]
    end
```

## Gravitational Time Dilation

```mermaid
flowchart LR
    A[Observer Time] --> E[Proper Time Calculation]
    B[Mass] --> C[Schwarzschild Radius]
    D[Distance] --> C
    C --> E
    E --> F[Proper Time]

    subgraph Schwarzschild Radius
    C
    end

    subgraph Formula
    G["rs = 2GM/c²"]
    H["Δt' = Δt × √(1-rs/r)"]
    end
```

## Curved Spacetime Calculation

```mermaid
flowchart TD
    A[Metric Tensor] --> D[Tensor Contraction]
    B[Coordinate Differentials] --> D
    D --> E[Proper Time Interval]

    subgraph Tensor Contraction
    D
    end

    subgraph Formula
    F["ds² = gμν dx^μ dx^ν"]
    G["dτ = √(-ds²)"]
    end
```

## Combined Time Dilation Effects

```mermaid
flowchart TD
    A[Velocity] --> B[Special Relativistic Factor]
    C[Mass] --> D[Gravitational Factor]
    E[Distance] --> D
    B --> F[Combined Time Dilation]
    D --> F
    G[Observer Time] --> F
    F --> H[Proper Time]

    subgraph Special Relativity
    B
    end

    subgraph General Relativity
    D
    end

    subgraph Formula
    I["γv = 1/√(1-v²/c²)"]
    J["γg = √(1-rs/r)"]
    K["Δt' = Δt × (γg/γv)"]
    end
```
